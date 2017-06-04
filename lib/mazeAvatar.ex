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
      cells: (for y <- 0..width_-1, x <- 0..height_-1, do: %{x: x, y: y, wall: true})
    }
  end


  # generates a map of the maze in Ascii format
  def drawMazeAscii(maze_) do
    _drawMap(maze_.cells)
    |> String.codepoints()
    |> Enum.chunk(maze_.width)
    |> Enum.join("\n")
  end


  # return true if x and y are inside outer walls of the grid
  # so for a grid a 5x5, the positions being 0 to 4, valid position is between 1 and 3 included
  def inGrid?(maze_, x_, y_) do
    x_>0 && y_>0 && x_<maze_.width-1 && y_<maze_.height-1
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
    y_ * maze_.width + x_
  end


  # return a cell from the maze at coordinates x y
  def getCellAt(maze_, x_, y_) do
    pos = getPos(maze_, x_, y_)
    Enum.at(maze_.cells, pos)
  end


  # returns a new grid with a cell dug at position x y
  def digCellAt(maze_, x_, y_) do
    pos = getPos(maze_, x_, y_)
    %{width: maze_.width,
      height: maze_.height,
      cells: List.replace_at(maze_.cells, pos, %{x: x_, y: y_, wall: false})
    }
  end


  # not sure about the algo, but let's continue for now
  # TODO fix for corners etc...
  def canDigAt?(maze_, {x_from_, y_from_}, {x_to_, y_to_}) do
    #arround = getCellsArround(maze_, x_to_, y_to_)

    # vector of where we dig to
    digDirection = {x_to_ - x_from_, y_to_ - y_from_}

    inGrid?(maze_, x_to_, y_to_)
    && case digDirection do
      { 1,  0} -> canDigRight?( maze_.cells, x_to_, y_to_)
      {-1,  0} -> canDigLeft?(  maze_.cells, x_to_, y_to_)
      {0 ,  1} -> canDigDown?(  maze_.cells, x_to_, y_to_)
      {0 , -1} -> canDigUp?(    maze_.cells, x_to_, y_to_)
      _ -> false # should not happen
    end
  end


  # TODO digging check per direction >>>
  def canDigRight?(cells_, x_, y_) do
    # 6 positions going down
    positions = [
      {x_  , y_-1}, {x_  , y_}, {x_  , y_+1},
      {x_+1, y_-1}, {x_+1, y_}, {x_+1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(cells_, positions) |> length
  end

  def canDigLeft?(cells_, x_, y_) do
    # 6 positions going down
    positions = [
      {x_  , y_-1}, {x_  , y_}, {x_  , y_+1},
      {x_-1, y_-1}, {x_-1, y_}, {x_-1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(cells_, positions) |> length
  end

  def canDigDown?(cells_, x_, y_) do
    # 6 positions going down
    positions = [
      {x_-1, y_  }, {x_, y_  }, {x_+1, y_  },
      {x_-1, y_+1}, {x_, y_+1}, {x_+1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(cells_, positions) |> length
  end

  def canDigUp?(cells_, x_, y_) do
    # 6 positions going down
    positions = [
      {x_-1, y_  }, {x_, y_  }, {x_+1, y_  },
      {x_-1, y_-1}, {x_, y_-1}, {x_+1, y_-1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(cells_, positions) |> length
  end

  # returns the cells that are wall at the positions in the list
  defp filterWalls(cells_, positions_) do
    Enum.filter(cells_, fn(cell) -> cell.wall && Enum.member?(positions_, {cell.x, cell.y}) end)
  end
  # <<<

end
