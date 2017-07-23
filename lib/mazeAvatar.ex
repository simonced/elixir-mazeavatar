defmodule MazeAvatar do

  @moduledoc """
  Documentation for MazeGenerator.
  Lib used: https://github.com/yuce/png
  """


  # TODO this function will generate the maze
  # @return maze as %{width, height, cell[]}
  def generate(width_, height_) do
    fillGrid(width_, height_)
    |> digEntrance()
    |> (fn m -> digMaze(m, m.entrance) end).()
  end


  # generate an entrance at the TOP of the maze at a random location
  def digEntrance(maze_) do
    x = :rand.uniform(maze_.width-2)

    # set the entrance
    %{maze_ | entrance: {x, 0}}
    |> digCellAt(x, 0, :path)
  end


  # randomly select an available position from "from_" and dig
  # @param from_ is a %{x, y} hash
  # @return maze
  def digMaze(maze_, from_) do
    getDiggableCellsFrom(from_)
    |> Enum.shuffle()
    |> Enum.reduce( maze_, fn to, m -> digMazeIfPossible(m, from_, to) end )
  end

  defp digMazeIfPossible(maze_, {x_from_, y_from_}, {x_to_, y_to_}) do
    case canDigAt?(maze_, {x_from_, y_from_}, {x_to_, y_to_}) do
      true	-> digCellAt(maze_, x_to_, y_to_) |> digExitTry({x_to_, y_to_}) |> digMaze({x_to_, y_to_})
      false -> maze_
    end
  end

  defp digExitTry(maze_, {x_, y_}) do
    height = maze_.height
    no_exit = maze_.exit == nil
    case y_ do
      y when y == height-2 and no_exit -> digExit(maze_, x_, y_+1)
      _ -> maze_
    end
  end


  defp digExit(maze_, x_, y_) do
    %{maze_ | exit: {x_, y_}}
    |> digCellAt(x_, y_, :path)
  end


  # generate a grid of the maze size
  # with only walls!
  # @return %{width, height, entrance = {x, y}, cells = [])}
  # each cell is a map %{x (int), y (int), type (:wall, :hole or :path)}
  # ?do I need to have a map for each cell? only a wall boolean could be enough maybe?
  # will see later
  def fillGrid(width_, height_) do
    # making a grid where each entry is a map with position and a flag
    %{
      width: width_,
      height: height_,
      entrance: nil,
	  exit: nil,
      cells: (for y <- 0..width_-1, x <- 0..height_-1, do: %{x: x, y: y, type: :wall})
    }
  end


  # generates a map of the maze in Ascii format
  def drawMazeAscii(maze_) do
    drawMap(maze_.cells)
    |> String.codepoints()
    |> Enum.chunk(maze_.width*2)
    |> Enum.join("\n")
  end


  # returns a list representing the cells
  # @param List cells
  defp drawMap(cells, map_ \\ "", position \\ 0)

  defp drawMap([], map_ , _), do: map_

  defp drawMap([cell_|cells_], map_ , position) do
    drawMap(cells_, map_ <> drawCell(cell_), position + 1)
  end


  # returns a character
  # - X if wall and SPACE otherwise
  defp drawCell(cell_) do
    case cell_.type do
      :wall -> "XX"
      :path -> ".."
      _    -> "  "
    end
  end


  # return true if x and y are inside outer walls of the grid
  # so for a grid a 5x5, the positions being 0 to 4, valid position is between 1 and 3 included
  def inGrid?(maze_, x_, y_) do
    x_>0 && y_>0 && x_<maze_.width-1 && y_<maze_.height-1
  end


  # calculate position in grid
  # @param grid a grid generated with fillGrid
  # @param x_ and y_ int
  # @return int
  def getPos(maze_, x_, y_) do
    y_ * maze_.width + x_
  end


  # @param int row_ : row number starts at 0
  def getRow(maze_, row_) do
 	start = maze_.width * row_
	Enum.slice(maze_.cells, start, maze_.width)
  end


  # return a cell from the maze at coordinates x y
  def getCellAt(maze_, x_, y_) do
    pos = getPos(maze_, x_, y_)
    Enum.at(maze_.cells, pos)
  end


  # returns a new grid with a cell dug at position x y
  def digCellAt(maze_, x_, y_, type \\ :hole) do
    pos = getPos(maze_, x_, y_)
    newCells = List.replace_at(maze_.cells, pos, %{x: x_, y: y_, type: type})
    %{maze_ | cells: newCells}
  end


  def getDiggableCellsFrom({x_, y_}) do
    # simply filter the possibilities
    [{x_, y_-1}, {x_+1, y_}, {x_, y_+1}, {x_-1, y_}]
  end


  # not sure about the algo, but let's continue for now
  def canDigAt?(maze_, {x_from_, y_from_}, {x_to_, y_to_}) do
    inGrid?(maze_, x_to_, y_to_)
    && case {x_to_ - x_from_, y_to_ - y_from_} do
      { 1,  0} -> canDigRight?( maze_, {x_to_, y_to_} )
      {-1,  0} -> canDigLeft?(  maze_, {x_to_, y_to_} )
      {0 ,  1} -> canDigDown?(  maze_, {x_to_, y_to_} )
      {0 , -1} -> canDigUp?(    maze_, {x_to_, y_to_} )
      _ -> false # should not happen
    end
  end


  # digging check per direction >>>
  def canDigRight?(maze_, {x_, y_}) do
    # 6 positions going down
    positions = [
      {x_  , y_-1}, {x_  , y_}, {x_  , y_+1},
      {x_+1, y_-1}, {x_+1, y_}, {x_+1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(maze_, positions) |> length
  end

  def canDigLeft?(maze_, {x_, y_}) do
    # 6 positions going down
    positions = [
      {x_  , y_-1}, {x_  , y_}, {x_  , y_+1},
      {x_-1, y_-1}, {x_-1, y_}, {x_-1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(maze_, positions) |> length
  end

  def canDigDown?(maze_, {x_, y_}) do
    # 6 positions going down
    positions = [
      {x_-1, y_  }, {x_, y_  }, {x_+1, y_  },
      {x_-1, y_+1}, {x_, y_+1}, {x_+1, y_+1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(maze_, positions) |> length
  end

  def canDigUp?(maze_, {x_, y_}) do
    # 6 positions going down
    positions = [
      {x_-1, y_  }, {x_, y_  }, {x_+1, y_  },
      {x_-1, y_-1}, {x_, y_-1}, {x_+1, y_-1}
    ]

    # we keep only the one that are walls, we should get 6
    6 == filterWalls(maze_, positions) |> length
  end

  # returns the cells that are wall at the positions in the list
  defp filterWalls(maze_, positions_) do
    Enum.filter positions_, fn({x, y}) -> getCellAt(maze_, x, y).type == :wall end
  end
  # <<<

end
