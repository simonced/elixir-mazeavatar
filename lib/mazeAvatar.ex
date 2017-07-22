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
    |> digExit()
  end


  # generate an entrance at the TOP of the maze at a random location
  def digEntrance(maze_) do
    x = :rand.uniform(maze_.width-2)

    # set the entrance
    %{maze_ | entrance: {x, 0}}
    |> digCellAt(x, 0)
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
      true -> digCellAt(maze_, x_from_, y_from_) |> digMaze({x_to_, y_to_})
      false -> maze_
    end
  end


  # make an exit at the BOTTOM of the maze
  def digExit(maze_) do
	# list possibilities on the lower path then we'll do a final dig for the exi
	s_start = getPos(maze_, 1, maze_.height - 2)
	s_end = getPos(maze_, maze_.width - 2, maze_.height - 2)
	exit = Enum.slice(maze_.cells, s_start..s_end)
	|> Enum.filter( &(&1.type == :hole) )
	|> Enum.random()

	%{ digCellAt(maze_, exit.x, exit.y+1) | exit: {exit.x, exit.y+1} }
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
    _drawMap(maze_.cells)
    |> String.codepoints()
    |> Enum.chunk(maze_.width*2)
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
    case cell_.type do
      :wall -> "XX"
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
  def digCellAt(maze_, x_, y_) do
    pos = getPos(maze_, x_, y_)
    newCells = List.replace_at(maze_.cells, pos, %{x: x_, y: y_, type: :hole})
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
