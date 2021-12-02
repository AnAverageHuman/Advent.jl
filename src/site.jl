using HTTP
using Dates: Minute, now, unix2datetime

base_url(year::Integer, day::Integer) = "https://adventofcode.com/$year/day/$day"
base_url(year::Integer) = "https://adventofcode.com/$year"

function make_request(url, session, outfile)
    res = HTTP.get(url, cookies = Dict("session" => session))
    res.status == 200 ? write(outfile, res.body) : error(res.body)
    outfile
end

"""
    save_input(year, day, [session])

Retrieves input for a given day and year and saves it in e.g. "day02.in" for day 2.
Returns the filename of the stored input.
If no session is provided, the environment variable `AOC_SESSION` is used.
If the file already exists, no request will be made.
"""
function save_input(year, day, session::AbstractString)
    outfile = string("day", string(day; pad=2), ".in")
    isfile(outfile) && return outfile
    make_request(base_url(year, day) * "/input", session, outfile)
end

save_input(year, day) = save_input(year, day, ENV["AOC_SESSION"])

"""
    save_leaderboard(year, num, [session])

Retrieves the leaderboard data for a given year and leaderboard number.
Returns the filename of the stored input.
If no session is provided, the environment variable `AOC_SESSION` is used.
If the file was modified less than 15 minutes ago, no request will be made.
"""
function save_leaderboard(year, num, session::AbstractString)
    outfile = string("leaderboard", num, ".json")
    now() - unix2datetime(mtime(outfile)) < Minute(15) && return outfile
    make_request(base_url(year) * "/leaderboard/private/view/$num.json", session, outfile)
end

save_leaderboard(year, num) = save_leaderboard(year, num, ENV["AOC_SESSION"])
