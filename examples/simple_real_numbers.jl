using OpenFHE: OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = OpenFHE.Parameters(multDepth, scaleModSize, batchSize)
context = OpenFHE.Context(parameters)

println("CKKS scheme is using ring dimension ", Int(OpenFHE.GetRingDimension(context)))
println()

keys = OpenFHE.KeyGen(context)

OpenFHE.EvalMultKeyGen(context, OpenFHE.private_key(keys))

OpenFHE.EvalRotateKeyGen(context, OpenFHE.private_key(keys), [1, -2])

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

ptxt1 = OpenFHE.MakeCKKSPackedPlaintext(context, x1)
ptxt2 = OpenFHE.MakeCKKSPackedPlaintext(context, x2)

println("Input x1: ", ptxt1)
println("Input x2: ", ptxt2)
