defmodule Mix.Tasks.Mazeavatargenerate do
  use Mix.Task

  def run([width_, height_]) do
    {width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)

    # benchmarking start
    prev = System.monotonic_time()

    MazeAvatar.generate( width, height )
    |> MazeAvatar.drawMazeAscii()
    |> IO.puts

    # bechmark end
    next = System.monotonic_time()

    IO.puts "Elapsed time: #{System.convert_time_unit(next - prev, :native, :millisecond)}ms"

  end

end
