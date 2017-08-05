defmodule Mix.Tasks.Generate do
  use Mix.Task

  def run([width_, height_]) do
    {width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)

    # benchmarking start
    prev = ElixirBenchmark.start()

    maze = MazeAvatar.generate( width, height )

    # bechmark end
    next = ElixirBenchmark.stop()

    IO.puts "Elapsed time: #{ElixirBenchmark.getMs(prev, next)}ms"

    MazeAvatar.drawMazeAscii(maze)
    |> IO.puts

	maze
  end

end



defmodule Mix.Tasks.GeneratePng do
  use Mix.Task

  def run([width_, height_, file_]) do
	{width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)

    # benchmarking start
    prev = ElixirBenchmark.start()

    maze = MazeAvatar.generate( width, height )

	# MazeAvatar.drawMazeAscii(maze)
	# |> IO.puts

    # bechmark end
    next = ElixirBenchmark.stop()

    IO.puts "Elapsed time: #{ElixirBenchmark.getMs(prev, next)}ms"

	# Next, generating the PNG file
	MazeAvatar.PNG.save(maze, file_ )
  end

end


defmodule Mix.Tasks.GeneratePngAnim do
  use Mix.Task

  def run([width_, height_, file_]) do
	{width, _} = Integer.parse(width_)
    {height, _} = Integer.parse(height_)

    MazeAvatar.generateAnim( width, height, file_ )
  end

end
