
defmodule MazeAvatar.PNG do

  # meanings:
  # - hole: open (dug) cell where we can walk
  # - wall: closed (non dug) cell
  # - path: open cell leading to the exit

  # constant keyword list
  @colors [hole: {255, 255, 255},
			wall: {0, 0, 0,},
			path: {255, 0, 0}]

  @colors_index [hole: 0,
				 wall: 1,
				 path: 2]


  # Save the maze as a PNG file
  def save(maze_, output_file_) do
    # 8bit palette with colors
    palette = {:rgb, 8, Keyword.values(@colors)}

	# destination file
    {_st, pic} = File.open(output_file_, [:write])
    png = :png.create( %{
		  :size    => {maze_.width, maze_.height},
		  :mode    => {:indexed, 8},
		  :file    => pic,
		  :palette => palette
					   } )

	# png file
	png = Enum.reduce(
	  1..maze_.height,
	  png,
	  fn(row_, png_) -> :png.append(png_, {:row, makeRow(maze_, row_)}) end
	)

    # finalize pic
    :png.close(png)
    File.close(pic)
  end


  # @param {int} row_ the row index we want
  # @return list of color indexes for the provided row
  defp makeRow(maze_, row_) do

	MazeAvatar.getRow(maze_, row_-1)
	|> Enum.map( &( case &1.type do
					  :wall -> @colors_index[:wall]
					  :hole -> @colors_index[:hole]
					  :path -> @colors_index[:path]
					end ))
  end

end
