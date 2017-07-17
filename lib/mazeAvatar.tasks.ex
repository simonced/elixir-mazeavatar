defmodule Mix.Tasks.Generate do
  use Mix.Task

  def run([width_, height_]) do
    {width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)

    # benchmarking start
    prev = ElixirBenchmark.start()

    MazeAvatar.generate( width, height )
    |> MazeAvatar.drawMazeAscii()
    |> IO.puts

    # bechmark end
    next = ElixirBenchmark.stop()

    IO.puts "Elapsed time: #{ElixirBenchmark.getMs(prev, next)}ms"

  end

end
