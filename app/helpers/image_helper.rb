module ImageHelper

  def self.crop_image_from_file(file, x, y, width, height)
    img = MiniMagick::Image.open(file.path)

    unless x.nil? || y.nil? || width.nil? || height.nil?
      ImageHelper::crop(img, x, y, width, height)
    end

    img.tempfile
  end

  def self.crop(img, x, y, width, height)
    ori_width = img[:width]
    ori_height = img[:height]

    x = x.to_i
    y = y.to_i
    width = width.to_i
    height = height.to_i

    x = x < 0 ? 0 : x
    y = y < 0 ? 0 : y
    width = width > ori_width ? ori_width : width
    height = height > ori_height ? ori_height : height

    img.crop "#{width}x#{height}+#{x}+#{y}"
    img
  end
end