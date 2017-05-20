defmodule MazeAvatarTest do
  use ExUnit.Case
  doctest MazeAvatar


  test "init grid" do
    assert MazeAvatar.fillGrid(2, 2) == [
      %{x: 0, y: 0, wall: true},
      %{x: 0, y: 1, wall: true},
      %{x: 1, y: 0, wall: true},
      %{x: 1, y: 1, wall: true}
    ]
  end


  test "find position" do
    grid = MazeAvatar.fillGrid(2,2)
    grid2 = MazeAvatar.digCellAt(grid, 0, 1)

    assert grid2 == [
      %{x: 0, y: 0, wall: false},
      %{x: 0, y: 1, wall: true},
      %{x: 1, y: 0, wall: false},
      %{x: 1, y: 1, wall: false}
    ]
  end


end
