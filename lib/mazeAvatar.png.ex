
defmodule MazeAvatar.PNG do

  @color_background {255, 255, 255}
  @color_walls {0, 0, 0,}
  
  # Save the maze as a PNG file
  def save(maze_, output_file_) do
    # 8bit palette with 4 colors
    palette = {:rgb, 8, [@color_background, @color_walls]}

	# destination file
    {st, pic} = File.open(output_file_, [:write])
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

  
  defp makeRow(maze_, row_) do

	row_cells = MazeAvatar.getRow(maze_, row_-1)
	
    Enum.map(row_cells, &( case &1.wall do
							 true -> 1
							 false -> 0
						   end ))
	
  end
  
end
