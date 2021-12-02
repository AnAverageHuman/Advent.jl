module Advent

import Base: iterate, eof, eltype, IteratorSize, read
import Base: replace

export
    # input
    read_charmatrix,
    eachlinegroup,

    # site
    save_input,
    save_leaderboard

include("parse.jl")
include("site.jl")

end
