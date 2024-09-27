begin
  require 'exifr/tiff'
rescue LoadError => exception
  raise exception unless exception.path == 'exifr/tiff'
end

module XMP::Handler
  class ExifrTIFF
    def call(object)
      return unless defined?(EXIFR::TIFF) && object.is_a?(EXIFR::TIFF)
      object.xmp || XMP::Document.new
    end
  end
end
