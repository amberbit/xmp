begin
  require 'exifr/jpeg'
rescue LoadError => exception
  raise exception unless exception.path == 'exifr/jpeg'
end

module XMP::Handler
  class Exifr
    def handle?(object)
      defined?(EXIFR::JPEG) and object.is_a?(EXIFR::JPEG)
    end

    def call(object)
      return unless handle? object
      xmp_chunk = object.app1s.find { |a| a =~ %r|\Ahttp://ns.adobe.com/xap/1.0/| }
      raise XMP::NoXMP, 'XMP section missing from JPEG' unless xmp_data = xmp_chunk&.split("\000")[1]
      xmp_data
    end
  end
end