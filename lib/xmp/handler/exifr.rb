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
        return if xmp_chunk.nil?
        format, xmp_data = 'jpeg', xmp_chunk.split("\000")[1]
      when EXIFR::TIFF then format, xmp_data = 'tiff', object.xmp
      else return
      end

      raise XMP::NoXMP, "XMP section missing from #{format}" unless xmp_data
      xmp_data
    end
  end
end
