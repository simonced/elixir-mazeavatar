defmodule Mix.Tasks.Mazeavatargenerate do
  use Mix.Task

  def run([width_, height_]) do
    {width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)
    MazeAvatar.generate( width, height )
    |> MazeAvatar.drawMaze
    |> IO.puts
  end

end
