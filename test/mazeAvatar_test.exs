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

end
