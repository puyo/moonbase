module Recolour
  def self.recolour(image, desired_rgb)
    desired_hsv = Color::ColorHSV.new_from_rgba(desired_rgb + [255])
    desired_hue = desired_hsv.h
    (0...image.height).each do |y|
      (0...image.width).each do |x|
        xy = [x, y]
        rgb = image.get_at(xy)
        hsv = Color::ColorHSV.new_from_rgba(rgb)
        new_hsv = Color::ColorHSV.new([desired_hue, hsv.s, hsv.v, hsv.a])
        image.set_at(xy, new_hsv.to_rgba_ary)
      end
    end
    image
  end
end
