module XMP
  require 'xmp/convenience'
  require 'xmp/document'
  require 'xmp/error'
  require 'xmp/handler'
  require 'xmp/handler/exifr_jpeg'
  require 'xmp/handler/exifr_tiff'
  require 'xmp/handler/file'
  require 'xmp/handler/xml'
  require 'xmp/namespace'
  require 'xmp/version'

  extend Handler
  self.handlers = [
    Handler::File.new('.jpg', '.jpeg') { |file| EXIFR::JPEG.new(file) },
    Handler::File.new('.tif', '.tiff') { |file| EXIFR::TIFF.new(file) },
    Handler::File.new('.xmp', '.xml')  { |file| Nokogiri::XML(file) },
    Handler::ExifrJPEG.new,
    Handler::ExifrTIFF.new,
    Handler::XML.new
  ]
end