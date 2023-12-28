using OpenFHE: OpenFHE

multDepth = 1
scaleModSize = 50
batchSize = 8

parameters = OpenFHE.Parameters(multDepth, scaleModSize, batchSize)
context = OpenFHE.Context(parameters)

println("CKKS scheme is using ring dimension ", Int(OpenFHE.GetRingDimension(context)))
println()
