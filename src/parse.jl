"""
    read_charmatrix(filename)

Reads the file `filename` into a matrix of characters.
"""
function read_charmatrix(filename::AbstractString)
    mat = mapreduce(collect, hcat, eachline(filename))::Matrix{Char}
    permutedims(mat)
end

function read_charmatrix(io::IO)
    mat = mapreduce(collect, hcat, eachline(io))::Matrix{Char}
    permutedims(mat)
end


# multiple replace (inefficient)
replace(s::String, oldnews::Pair...) = foldl(replace, oldnews, init=s)

## working with files where the input is in groups

struct FileGroup <: IO
    stream::IO
    separator::AbstractString
    isinner::Bool
    FileGroup(stream::IO, separator::AbstractString, isinner=false) = new(stream, separator, isinner)
end

function iterate(itr::FileGroup, state=nothing)
    if eof(itr.stream)
        close(itr.stream)
        return nothing
    elseif itr.isinner
        line = readline(itr.stream)
        line == itr.separator ? nothing : (line, nothing)
    else
        FileGroup(itr.stream, itr.separator, true), nothing
    end
end

eltype(::Type{<:FileGroup}) = String

IteratorSize(::Type{<:FileGroup}) = Base.SizeUnknown()

eof(itr::FileGroup) = eof(itr.stream)

read(itr::FileGroup, ::Type{UInt8}) = read(itr.stream, UInt8)

function eachlinegroup(filename::AbstractString, separator="")
    FileGroup(open(filename), separator)
end
