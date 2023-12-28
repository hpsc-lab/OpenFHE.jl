using OpenFHE: OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = OpenFHE.Parameters(multDepth, scaleModSize, batchSize)
context = OpenFHE.Context(parameters)

println("CKKS scheme is using ring dimension ", Int(OpenFHE.GetRingDimension(context)))
println()

keys = OpenFHE.KeyGen(context)

EvalMultKeyGen(context, keys.private_key())

EvalRotateKeyGen(context, keys.private_key(), [1, -2])

x1 = [0.25, 0.5, 0.75, 1.0, 2.0, 3.0, 4.0, 5.0]
x2 = [5.0, 4.0, 3.0, 2.0, 1.0, 0.75, 0.5, 0.25]

ptxt1 = MakeCKKSPackedPlaintext(context, x1)
ptxt2 = MakeCKKSPackedPlaintext(context, x2)
