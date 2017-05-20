defmodule MazeAvatar do
  @moduledoc """
  Documentation for MazeGenerator.
  Lib used: https://github.com/yuce/png
  """


  # main genaration entry point
  def generateAndSavePng(width_, height_) do
    generate(height_, width_)
    |> savePng()
  end


  # TODO
  def generate(width_, height_) do
    IO.puts "TODO"
  end


  # TODO
  def savePng(grid_) do
    IO.puts "TODO"
  end


  # generate a grid of the maze size
  # with only walls!
  # each cell is a map %{x (int), y (int), wall (boolean)}
  def fillGrid(width_, height_) do
    # making a grid where each entry is a map with position and a flag
    for x <- 0..width_-1, y <- 0..height_-1, do: %{x: x, y: y, wall: true}
  end


  # returns a new grid with a cell dug at position x y
  def digCellAt(grid_, x_, y_) do
    IO.puts "=== TODO ==="
  end
end
