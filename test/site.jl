using HTTP
using SimpleMock

@testset "save input" begin
    mktempdir() do path
        cd(path) do
            # without environment variable
            @test_throws KeyError Advent.save_input(2020, 4)

            response = HTTP.Response(500, "some error")
            mock(HTTP.get => Mock(response)) do mock_response
                @test_throws ErrorException Advent.save_input(2020, 4, "session")
                @test called_once(mock_response)
            end

            response = HTTP.Response(200, "the response")
            mock(HTTP.get => Mock(response)) do mock_response
                @test "day04.in" === Advent.save_input(2020, 4, "session")
                @test readlines("day04.in") == ["the response"]

                # HTTP.get should only be called the first time since we cache input
                @test "day04.in" === Advent.save_input(2020, 4, "session")
                @test called_once(mock_response)
            end
        end
    end
end
