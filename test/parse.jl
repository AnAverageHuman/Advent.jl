@testset "read character matrix" begin
    mktemp() do path, _
        write(
            path,
            """
            1####2####
            ####3####4
            #5#6#7#8#9
            """
        )

        matrix = Advent.read_charmatrix(path)
        @test size(matrix) == (3, 10)
        @test matrix isa Matrix{Char}
        @test matrix[1, 1] == '1'
        @test matrix[3, 10] == '9'
    end
end
