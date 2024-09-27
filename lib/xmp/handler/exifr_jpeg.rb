begin
  require 'exifr/jpeg'
rescue LoadError => exception
  raise exception unless exception.path == 'exifr/jpeg'
end

module XMP::Handler
  class ExifrJPEG
    def call(object)
      return unless defined?(EXIFR::JPEG) && object.is_a?(EXIFR::JPEG)
      xmp_chunk = object.app1s.find { |a| a =~ %r|\Ahttp://ns.adobe.com/xap/1.0/| }
      xmp_chunk ? xmp_chunk.split("\000")[1] : XMP::Document.new
    end
  end
end
