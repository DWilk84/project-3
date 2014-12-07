module MosaicMaker
  include Magick

  def self.create_new(mosaic)
    @mosaic = mosaic

    #######################################
    # constants
    startTime = Time.now
    max_width = 1000
    tile_width = 100
    tile_height = 100
    output_directory = "/Users/davidwilkinson/Google_Drive/General_Assembly/WDI9/WDI_LDN_9_Projects/Project_3/pixelpic/public/uploads/mosaic"
    
    output_filename = @mosaic.name
    path = "#{output_directory}/#{output_filename}.jpg"
    relative_path = "/uploads/mosaic/#{output_filename}.jpg"
    
    #######################################
    # collect and amend the target image
    puts "reading images"

    target_image = Image.read(@mosaic.images.last.file.path)[0]

    width = target_image.columns.to_f
    height = target_image.rows.to_f
    
    width_multiplier = max_width / width

    width = (width * width_multiplier).to_i
    height = (height * width_multiplier).to_i

    target_image = target_image.resize_to_fit(width, height)
    
    #######################################
    # collect the list of images for the background tiles

    tile_list = ImageList.new()
    
    @mosaic.images.each do |img|
      image = Image.read(img.file.path)[0]
      tile_list.push(image)
    end

    #######################################
    # create the tiled background image by:
    puts "generating tiled background"

    # 1) creating a blank background image to put the tiles on
    tiled_image = Image.new(width, height)

    # 2) resizing and greyscaling the images in the file list,
    tiles = []
    tile_list.each do |tile|
      tile = tile.resize_to_fill(tile_width, tile_height, NorthGravity).quantize(256, GRAYColorspace)
      tiles.push(tile)
    end

    # 3) creating a new array from these images with length equal to
    # the number of tiles required to cover the blank background
    tile_cols = width / tile_width
    tile_rows = height / tile_height
    num_tiles = tile_cols * tile_rows

    random_tiles = num_tiles.times.inject([]) do |arr, tile|
      arr.push(tiles.sample)
    end

    # 4) overlaying these tiles on the blank background image
    random_tiles.each_with_index do |tile, index|
      tiled_image.composite!( tile, index%tile_cols * tile_width, index/tile_cols * tile_height, OverCompositeOp )
    end
    
    #######################################
    # create the output image by overcompositing (using RMagick dissolve method) the
    # target image onto the background and then writing this to the AWS folder
    puts "writing output"
    
    tiled_image.dissolve(target_image, "80%", 1.00).write(path)

    # # can create 10 images with varying degrees of dissolve property from 0-100% as follows:
    # (0..100).step(10).each do |x|
    #   tiled_image.dissolve(target_image, "#{x}%", 1.00).write("#{output_directory}/dissolved_#{x}.jpg")
    # end
    
    #######################################
    # return the path for the mosaic file that has been created
    # S3 gem can be used to write the file to AWS S3

    puts "complete"
    endTime = Time.now
    puts "#{(endTime - startTime)} seconds"

    relative_path
  end

end