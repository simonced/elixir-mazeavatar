defmodule MazeAvatarTest do
  use ExUnit.Case
  doctest MazeAvatar


  test "init grid" do
    assert MazeAvatar.fillGrid(2, 2) == %{
      width: 2,
      height: 2,
      cells: [
        %{x: 0, y: 0, wall: true},
        %{x: 1, y: 0, wall: true},
        %{x: 0, y: 1, wall: true},
        %{x: 1, y: 1, wall: true}
      ]
    }
  end


  test "get position" do
    maze = MazeAvatar.fillGrid(2, 2)
    assert MazeAvatar.getPos(maze, 1, 1) == 3
    assert MazeAvatar.getPos(maze, 0, 1) == 2
  end


  test "dig a hole" do
    maze2 = MazeAvatar.fillGrid(2,2)
            |> MazeAvatar.digCellAt(0, 1)

    assert maze2.cells == [
      %{x: 0, y: 0, wall: true},
      %{x: 1, y: 0, wall: true},
      %{x: 0, y: 1, wall: false},
      %{x: 1, y: 1, wall: true}
    ]
  end


  test "draw Ascii maze" do
    mazeMap = MazeAvatar.fillGrid(2, 2)
              |> MazeAvatar.digCellAt(0, 1)
              |> MazeAvatar.drawMazeAscii()

    assert mazeMap == "XX\n X"
  end


  test "is position inside the outer walls of the grid" do
    maze = MazeAvatar.fillGrid(5, 5)

    assert true  == MazeAvatar.inGrid?(maze, 1, 1)
    assert true  == MazeAvatar.inGrid?(maze, 3, 3)
    assert false == MazeAvatar.inGrid?(maze, 0, 1) # false because in the wall in the left
    assert false == MazeAvatar.inGrid?(maze, 4, 5) # false because in the wall at the bottom
  end


  test "check wall arround a position" do
    # will be used when randomly digging
    mazeMap = MazeAvatar.fillGrid(5, 5)
              |> MazeAvatar.digCellAt(2, 0)
    #IO.puts "\n"
    #IO.puts MazeAvatar.drawMazeAscii(mazeMap)

    # we check if we can dig at 2,1
    # for that to be possible
    # dig down check
    assert true == MazeAvatar.canDigAt?(mazeMap, {2, 0}, {2, 1})

    # what about the case bellow
    # - ? is where we try to dig
    #  |01234
    # -------
    # 0|XX XX
    # 1|XX  X
    # 2|XX?XX
    # 3|XXXXX
    # 4|XXXXX
    mazeMap2 = MazeAvatar.digCellAt(mazeMap, 2, 1) |> MazeAvatar.digCellAt(3, 1)

    # that shows that the algorithm should only check the 6 cells forward to where we dig
    # Like so
    #  |01234
    # -------
    # 0|XX XX
    # 1|XXO X
    # 2|XA?AX
    # 3|XAAAX
    # 4|XXXXX
    # only A blocks should be checked when digging from O
    assert true == MazeAvatar.canDigAt?(mazeMap2, {2, 1}, {2, 2})

    # next we test a position to dig that should not be allowed
    mazeMap3 = MazeAvatar.digCellAt(mazeMap2, 3, 2)
    assert false == MazeAvatar.canDigAt?(mazeMap3, {2, 1}, {2, 2})

  end

  
  test "dig an entrance at a random location on the top layer" do
    maze = MazeAvatar.fillGrid(5, 1)
           |> MazeAvatar.digEntrance()
           |> MazeAvatar.drawMazeAscii()

    possibilities = ["X XXX", "XX XX", "XXX X"]

    assert Enum.member?(possibilities, maze)
    #IO.puts maze
  end


end
