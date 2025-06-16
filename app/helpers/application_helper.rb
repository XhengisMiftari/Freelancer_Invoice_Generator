require 'open-uri'

module ApplicationHelper
  def base64_image(key)
    url = key
    image_data = URI.open(url).read
    base64 = Base64.strict_encode64(image_data)
    "data:image/png;base64,#{base64}"
  end
end
