"""
    read_charmatrix(filename)

Reads the file `filename` into a matrix of characters.
"""
function read_charmatrix(filename::AbstractString)
    mat = mapreduce(collect, hcat, eachline(filename))::Matrix{Char}
    permutedims(mat)
end
