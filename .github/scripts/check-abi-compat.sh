#!/usr/bin/env bash
#
# Checks ABI compatibility between all OpenFHE_jll and openfhe_julia_jll
# version combinations permitted by Project.toml [compat].
#
# Output (stdout): Markdown report with compatibility table.
# Exit:  0 = all compatible, 1 = incompatibilities found, 2 = error.
#
# Requirements: bash 4+, gh (authenticated), julia, nm, c++filt

set -euo pipefail

WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT

has_incompatibility=false

# ── Helpers ──────────────────────────────────────────────────────────

log()    { echo "::group::$*" >&2; }
endlog() { echo "::endgroup::" >&2; }

read_compat() {
    julia --startup-file=no -e "
        using TOML
        print(TOML.parsefile(\"Project.toml\")[\"compat\"][\"$1\"])
    "
}

# Emit "version\ttag" lines for a JuliaBinaryWrappers JLL repo,
# one per unique version (latest build number wins).
list_versions() {
    local repo=$1
    gh api "repos/JuliaBinaryWrappers/${repo}/releases" \
        --paginate --jq '.[].tag_name' |
        sed -n 's/.*v\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\).*/\1\t&/p' |
        sort -t$'\t' -k1,1V -k2,2Vr |
        sort -t$'\t' -k1,1V -u
}

# Stdin: "version\ttag" lines → only those whose version satisfies the spec.
filter_compat() {
    local spec=$1
    julia --startup-file=no -e '
        using Pkg
        spec = Pkg.Types.semver_spec(ARGS[1])
        for line in eachline(stdin)
            v = tryparse(VersionNumber, split(line, "\t")[1])
            v !== nothing && v in spec && println(line)
        end
    ' "$spec"
}

# Download a release asset matching a regex into $dest.
download_asset() {
    local repo=$1 tag=$2 dest=$3 regex=$4
    local url
    url=$(gh api "repos/JuliaBinaryWrappers/${repo}/releases/tags/${tag}" \
        --jq "[.assets[] | select(.name | test(\"${regex}\"))]
              | sort_by(.name) | last | .browser_download_url")

    if [[ -z "$url" || "$url" == "null" ]]; then
        echo "  ⚠ no asset matching '${regex}' for ${repo} ${tag}" >&2
        return 1
    fi

    mkdir -p "$dest"
    curl -sSL "$url" | tar xz -C "$dest"
}

# Find lbcrypto:: symbols the wrapper needs but OpenFHE doesn't provide.
# Output: "mangled\tdemangled" per line.
find_missing() {
    local wdir=$1 odir=$2
    comm -23 \
        <(nm -D --undefined-only "$wdir"/lib/libopenfhe_julia.so* 2>/dev/null |
            awk '{print $2}' | sort -u) \
        <(nm -D --defined-only "$odir"/lib/libOPENFHE*.so* 2>/dev/null |
            awk '{print $3}' | sort -u) |
        while IFS= read -r sym; do
            d=$(c++filt <<< "$sym")
            if [[ $d == lbcrypto::* ]]; then
                printf '%s\t%s\n' "$sym" "$d"
            fi
        done || true
}

# "lbcrypto::DCRTPolyImpl<…>::Method(…)" → "DCRTPolyImpl::Method"
short_name() {
    sed -E ':a; s/<[^<>]*>//g; ta; s/^lbcrypto:://; s/\(.*//; s/ .*//'
}

# Extract bare method name from demangled symbol:
# "lbcrypto::DCRTPolyImpl<…>::DropLastElementAndScale(…)" → "DropLastElementAndScale"
method_name() {
    sed -E ':a; s/<[^<>]*>//g; ta; s/\(.*//; s/.*:://'
}

# Look up matching symbols in OpenFHE's provided set by method name.
# Args: method, provided_symbols_file
# Output: demangled signatures, one per line.
find_new_signatures() {
    local method=$1 provided_file=$2
    [[ -f "$provided_file" ]] || return 0
    grep "$method" "$provided_file" | c++filt | grep "::${method}(" || true
}

# Strip namespace prefixes and default allocators for readability.
simplify_sig() {
    sed -E '
        s/std:://g; s/intnat:://g; s/lbcrypto:://g
        s/bigintdyn:://g; s/bigintfxd:://g
        :a; s/, allocator<[^<>]*>//g; ta
        s/  +/ /g
    '
}

# Split a C++ signature's parameters to one per line (handles nested <>).
split_params() {
    awk '
    {
        p = index($0, "(")
        if (p == 0) { print; next }
        pre = substr($0, 1, p)
        rest = substr($0, p + 1)
        if (substr(rest, length(rest)) == ")")
            rest = substr(rest, 1, length(rest) - 1)
        print pre
        depth = 0; cur = ""
        for (i = 1; i <= length(rest); i++) {
            c = substr(rest, i, 1)
            if (c == "<") { depth++; cur = cur c }
            else if (c == ">") { depth--; cur = cur c }
            else if (c == "," && depth == 0) {
                gsub(/^ +| +$/, "", cur)
                printf "    %s,\n", cur
                cur = ""
                if (i < length(rest) && substr(rest, i+1, 1) == " ") i++
            }
            else { cur = cur c }
        }
        gsub(/^ +| +$/, "", cur)
        if (cur != "") printf "    %s\n", cur
        print ")"
    }'
}

# ── 1. Parse compat bounds ───────────────────────────────────────────

log "Parsing Project.toml compat bounds"
OPENFHE_COMPAT=$(read_compat OpenFHE_jll)
WRAPPER_COMPAT=$(read_compat openfhe_julia_jll)
echo "  OpenFHE_jll:        ${OPENFHE_COMPAT}" >&2
echo "  openfhe_julia_jll:  ${WRAPPER_COMPAT}" >&2
endlog

# ── 2. Discover compatible versions ──────────────────────────────────

log "Discovering compatible JLL versions"

declare -A O_TAG W_TAG
O_VERS=() W_VERS=()

while IFS=$'\t' read -r v t; do
    O_VERS+=("$v"); O_TAG[$v]=$t
done < <(list_versions "OpenFHE_jll.jl" | filter_compat "$OPENFHE_COMPAT")

while IFS=$'\t' read -r v t; do
    W_VERS+=("$v"); W_TAG[$v]=$t
done < <(list_versions "openfhe_julia_jll.jl" | filter_compat "$WRAPPER_COMPAT")

for v in "${O_VERS[@]:-}"; do echo "  OpenFHE_jll $v  (${O_TAG[$v]})" >&2; done
for v in "${W_VERS[@]:-}"; do echo "  openfhe_julia_jll $v  (${W_TAG[$v]})" >&2; done
endlog

if (( ${#O_VERS[@]} == 0 )) || (( ${#W_VERS[@]} == 0 )); then
    echo "No compatible versions found for the current compat bounds."
    exit 0
fi

# ── 3. Download artifacts ────────────────────────────────────────────

log "Downloading JLL artifacts"
for v in "${O_VERS[@]}"; do
    echo "  OpenFHE_jll ${v}…" >&2
    download_asset "OpenFHE_jll.jl" "${O_TAG[$v]}" "$WORK/o/$v" \
        'x86_64-linux-gnu-cxx11[.]tar[.]gz$' || true
done
for v in "${W_VERS[@]}"; do
    echo "  openfhe_julia_jll ${v}…" >&2
    download_asset "openfhe_julia_jll.jl" "${W_TAG[$v]}" "$WORK/w/$v" \
        'x86_64-linux-gnu-cxx11-julia_version' || true
done
endlog

# ── 4. Compare symbols ──────────────────────────────────────────────

log "Comparing symbols"
declare -A RESULT

for ov in "${O_VERS[@]}"; do
    if [[ -d "$WORK/o/$ov/lib" ]]; then
        nm -D --defined-only "$WORK/o/$ov"/lib/libOPENFHE*.so* 2>/dev/null |
            awk '{print $3}' | sort -u > "$WORK/provided_${ov}.txt"
    fi
    for wv in "${W_VERS[@]}"; do
        k="${ov},${wv}"
        if [[ ! -d "$WORK/o/$ov/lib" || ! -d "$WORK/w/$wv/lib" ]]; then
            RESULT[$k]="UNAVAILABLE"
            echo "  ${ov} × ${wv}: artifact missing" >&2
            continue
        fi
        m=$(find_missing "$WORK/w/$wv" "$WORK/o/$ov")
        RESULT[$k]=$m
        if [[ -z "$m" ]]; then
            echo "  ${ov} × ${wv}: ✅" >&2
        else
            n=$(wc -l <<< "$m")
            echo "  ${ov} × ${wv}: ❌ ${n} symbol(s)" >&2
            has_incompatibility=true
        fi
    done
done
endlog

# ── 5. Markdown report ──────────────────────────────────────────────

echo "<!-- abi-compat -->"
echo "# ABI Compatibility: OpenFHE_jll × openfhe_julia_jll"
echo ""
echo "Compat bounds from \`Project.toml\`:"
echo "- \`OpenFHE_jll\`: \`${OPENFHE_COMPAT}\`"
echo "- \`openfhe_julia_jll\`: \`${WRAPPER_COMPAT}\`"
echo ""

# Table header
printf '%s' '| OpenFHE_jll \ openfhe_julia_jll |'
for wv in "${W_VERS[@]}"; do printf ' **%s** |' "$wv"; done
echo ""
printf '%s' '|---|'
for _ in "${W_VERS[@]}"; do printf '%s' '---|'; done
echo ""

# Table rows + accumulate detail sections
details=""
for ov in "${O_VERS[@]}"; do
    printf '| **%s** |' "$ov"
    for wv in "${W_VERS[@]}"; do
        k="${ov},${wv}"
        r=${RESULT[$k]}
        if [[ "$r" == "UNAVAILABLE" ]]; then
            printf ' ⚠️ no artifact |'
        elif [[ -z "$r" ]]; then
            printf ' ✅ |'
        else
            n=$(wc -l <<< "$r")
            names=$(cut -f2 <<< "$r" | short_name | paste -sd ', ')
            printf ' ❌ %s |' "$names"

            details+=$'\n'"### OpenFHE_jll ${ov} × openfhe_julia_jll ${wv}"$'\n\n'
            details+="<details><summary>${n} incompatible symbol(s)</summary>"$'\n\n'
            while IFS=$'\t' read -r mangled demangled; do
                sname=$(short_name <<< "$demangled")
                method=$(method_name <<< "$demangled")

                # Filter new signatures to matching template specialization
                class_tmpl=$(sed "s/::${method}(.*//" <<< "$demangled")
                all_new=$(find_new_signatures "$method" "$WORK/provided_${ov}.txt")
                new_sig=$(grep -F "$class_tmpl" <<< "$all_new" | head -1)

                old_fmt=$(simplify_sig <<< "$demangled" | split_params)

                details+="#### \`${sname}\`"$'\n\n'
                if [[ -n "$new_sig" ]]; then
                    new_fmt=$(simplify_sig <<< "$new_sig" | split_params)
                    sig_diff=$(diff -U999 <(echo "$old_fmt") <(echo "$new_fmt") | tail -n +3 || true)
                    details+="\`\`\`diff"$'\n'"${sig_diff}"$'\n'"\`\`\`"$'\n\n'
                else
                    details+="\`\`\`cpp"$'\n'"${old_fmt}"$'\n'"\`\`\`"$'\n'
                    details+="Symbol removed from OpenFHE_jll."$'\n\n'
                fi
            done <<< "$r"
            details+="</details>"$'\n'
        fi
    done
    echo ""
done

if [[ -n "$details" ]]; then
    echo ""
    echo "## Details"
    echo "$details"
fi

if $has_incompatibility; then
    exit 1
else
    exit 0
fi
