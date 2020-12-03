using HTTP

base_url(year::Integer, day::Integer) = "https://adventofcode.com/$year/day/$day"

"""
    save_input(year, day, [session])

Retrieves input for a given day and year and saves it in e.g. "day2.in" for day 2.
Returns the filename of the stored input.
If no session is provided, the environment variable `AOC_SESSION` is used.
If the file already exists, no request will be made.
"""
function save_input(year, day, session::AbstractString)
    outfile = string("day", day, ".in")
    isfile(outfile) && return outfile

    res = HTTP.get(base_url(year, day) * "/input", cookies = Dict("session" => session))
    res.status == 200 ?  write(outfile, res.body) : error(res.body)
    outfile
end

save_input(year, day) = save_input(year, day, ENV["AOC_SESSION"])

