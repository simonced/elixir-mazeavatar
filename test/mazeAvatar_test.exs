defmodule MazeAvatarTest do
  use ExUnit.Case
  doctest MazeAvatar


  test "init grid" do
    assert MazeAvatar.fillGrid(2, 2) == %{width: 2, height: 2, cells: [
      %{x: 0, y: 0, wall: true},
      %{x: 0, y: 1, wall: true},
      %{x: 1, y: 0, wall: true},
      %{x: 1, y: 1, wall: true}
    ]}
  end


  test "get position" do
    maze = MazeAvatar.fillGrid(2, 2)
    assert MazeAvatar.getPos(maze, 1, 1) == 3
  end


  test "dig a hole" do
    maze = MazeAvatar.fillGrid(2,2)
    maze2 = MazeAvatar.digCellAt(maze, 0, 1)

    assert maze2.cells == [
      %{x: 0, y: 0, wall: true},
      %{x: 0, y: 1, wall: false},
      %{x: 1, y: 0, wall: true},
      %{x: 1, y: 1, wall: true}
    ]
  end


  test "draw Ascii maze" do
    IO.puts "TODO"
  end

end
