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


  # TODO this function will generate the maze
  # @return maze as %{width, height, cell[]}
  def generate(width_, height_) do
    fillGrid(width_, height_)
           |> digEntrance()
           |> digMaze()
           |> digExit()
  end


  # TODO generate an entrance an the TOP of the maze at a random location
  def digEntrance(maze_) do
    maze_
  end


  # TODO starts from entrance and generate path randomly
  def digMaze(maze_) do
    maze_
  end


  # TODO find a position for the exit at the BOTTOM of the maze
  def digExit(maze_) do
    maze_
  end


  # TODO
  def savePng(_grid_) do
    IO.puts "TODO"
  end


  # generate a grid of the maze size
  # with only walls!
  # @return %{width, height, cells[])}
  # each cell is a map %{x (int), y (int), wall (boolean)}
  # ?do I need to have a map for each cell? only a wall boolean could be enough maybe?
  # will see later
  def fillGrid(width_, height_) do
    # making a grid where each entry is a map with position and a flag
    %{
      width: width_,
      height: height_,
      cells: (for x <- 0..width_-1, y <- 0..height_-1, do: %{x: x, y: y, wall: true})
    }
  end


  # generates a map of the maze
  def drawMaze(maze_) do
    _drawMap(maze_.cells)
    |> String.codepoints()
    |> Enum.chunk(maze_.width)
    |> Enum.join("\n")
  end


  # returns a list representing the cells
  # @param List cells
  def _drawMap(cells, map_ \\ "", position \\ 0)

  def _drawMap([], map_ , _), do: map_

  def _drawMap([cell_|cells_], map_ , position) do
    _drawMap(cells_, map_ <> drawCell(cell_), position + 1)
  end


  # returns a character
  # - X if wall and SPACE otherwise
  def drawCell(cell_) do
    case cell_.wall do
      true -> "X"
      _ -> " "
    end
  end


  # calculate position in grid
  # @param grid a grid generated with fillGrid
  # @param x_ and y_ int
  # @return int
  def getPos(maze_, x_, y_) do
    maze_.width * x_ + y_
  end


  # return a cell from the maze at coordinates x y
  def getCellAt(maze_, x_, y_) do
    pos = getPos(maze_, x_, y_)
    Enum.at(maze_.cells, pos)
  end


  # returns a new grid with a cell dug at position x y
  def digCellAt(maze_, x_, y_) do
    %{width: maze_.width,
      height: maze_.height,
      cells: List.replace_at(maze_.cells, getPos(maze_, x_, y_), %{x: x_, y: y_, wall: false})
    }
  end
end
