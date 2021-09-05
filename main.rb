require 'mini_magick'

filename = "RE00712.png"
tempfile_path = ''

Tempfile.open([filename, '.png']) do |tempfile|
  tempfile_path = tempfile.path
end

background = MiniMagick::Image.open('images/background.jpg')

art_width = 500
background_width = background.width

MiniMagick::Tool::Convert.new do |convert|
  convert << 'images/RE00712.jpg'
  convert.resize(background_width / 100 * art_width * 0.045)

  convert.stack do |stack|
    stack.clone.+
    stack.background('gray')
    stack.shadow('80x3+5+5')
  end

  convert.swap.+
  convert.background('none')
  convert.layers('merge')
  convert.repage.+
  convert << tempfile_path
end

resized_art = MiniMagick::Image.new(tempfile_path)

result = background.composite(resized_art) do |c|
  c.compose 'Over'
  c.gravity 'North'
  c.geometry '-5+110'
end

result.write('images/result.jpg')
