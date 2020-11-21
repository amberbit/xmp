module XMP
  require 'xmp/convenience'
  require 'xmp/document'
  require 'xmp/error'
  require 'xmp/handler'
  require 'xmp/handler/exifr'
  require 'xmp/handler/file'
  require 'xmp/handler/xml'
  require 'xmp/namespace'
  require 'xmp/version'

  extend Handler
  self.handlers = [
    Handler::File.new('.jpg', '.jpeg') { |file| EXIFR::JPEG.new(file) },
    Handler::File.new('.tiff')         { |file| EXIFR::TIFF.new(file) },
    Handler::File.new('.xmp', '.xml')  { |file| Nokogiri::XML(file) },
    Handler::Exifr.new,
    Handler::XML.new
  ]
end