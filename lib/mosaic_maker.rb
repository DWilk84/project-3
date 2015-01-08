module MosaicMaker
  include Magick

  def self.create_new(mosaic)
    @mosaic = mosaic

    #######################################
    # constants
    startTime = Time.now
    max_width_large = 3001
    max_width_small = 401
    small_width_multiplier = max_width_small.to_f / max_width_large.to_f
    tile_width = 100
    tile_height = 100
    output_directory = "#{Rails.public_path}/uploads/mosaic"
    
    output_filename_large = "mosaic_#{@mosaic.id}_#{@mosaic.name}_large.jpg"
    output_filename_small = "mosaic_#{@mosaic.id}_#{@mosaic.name}_small.jpg"

    path_large = "#{output_directory}/#{output_filename_large}"
    path_small = "#{output_directory}/#{output_filename_small}"
    
    #######################################
    # collect and amend the target image
    puts "reading images"
    image_array = @mosaic.images
    target_image = image_array.pop
    image_array -= [target_image]
    target_image = Image.read(target_image.file.path)[0]

    width = target_image.columns.to_f
    height = target_image.rows.to_f
    width_multiplier = max_width_large / width

    width = (width * width_multiplier).to_i
    height = (height * width_multiplier).to_i
    height = height - height % tile_height

    target_image = target_image.resize_to_fill(width, height, CenterGravity)
    
    #######################################
    # collect the list of images for the background tiles

    tile_list = ImageList.new()
    
    image_array.each do |img|
      image = Image.read(img.file.path)[0]
      tile_list.push(image)
    end

    #######################################
    # create the tiled background image by:
    puts "generating tiled background"

    # 1) creating a blank background image to put the tiles on
    tiled_image = Image.new(width, height)

    # 2) resizing and greyscaling the images in the file list
    tiles = []
    tile_list.each do |tile|
      tile = tile.resize_to_fill(tile_width, tile_height, NorthGravity).quantize(256, GRAYColorspace)
      # tile = tile.resize_to_fill(tile_width, tile_height, NorthGravity)
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
    # generate an instance of the AWS S3 interface
    s3 = AWS::S3.new
    b = s3.buckets["pixelpic"]

    #######################################
    # create the output image by overcompositing (using RMagick dissolve method) the
    # target image onto the background and then writing this to the AWS folder
    puts "writing output"
    
    t_large = tiled_image.dissolve(target_image, "70%", 1.00)
    t_large.write(path_large)

    width = (width * small_width_multiplier).to_i
    height = (height * small_width_multiplier).to_i
    t_small = t_large.resize_to_fit(width, height)
    t_small.write(path_small)

    o = b.objects[output_filename_large]
    o.write(file: path_large)
    path_large = o.url_for(:read).to_s

    o = b.objects[output_filename_small]
    o.write(file: path_small)
    path_small = o.url_for(:read).to_s

    paths = [path_large, path_small]
    # # can create 10 images with varying degrees of dissolve property from 0-100% as follows:
    # (0..100).step(10).each do |x|
    #   tiled_image.dissolve(target_image, "#{x}%", 1.00).write("#{output_directory}/dissolved_#{x}.jpg")
    # end
    
    #######################################
    # return the path for the mosaic file that has been created as the last item....

    puts "complete"
    endTime = Time.now
    puts "#{(endTime - startTime)} seconds"

    # return the file paths
    paths

  end

end