begin
  require 'exifr/jpeg'
  require 'exifr/tiff'
rescue LoadError => exception
  raise exception unless exception.path == 'exifr/jpeg'
end

module XMP::Handler
  class Exifr
    def call(object)
      return unless defined?(EXIFR::JPEG)
      case object
      when EXIFR::JPEG
        xmp_chunk = object.app1s.find { |a| a =~ %r|\Ahttp://ns.adobe.com/xap/1.0/| }
        if xmp_chunk
          xmp_data = xmp_chunk.split("\000")[1]
        else
          xmp_data = XMP::Document.new
        end
      when EXIFR::TIFF
        xmp_data = object.xmp || XMP::Document.new
      else return
      end
      xmp_data
    end
  end
end
