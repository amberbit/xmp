require 'nokogiri'

module XMP::Handler
  class XML
    def call(object)
      object = Nokogiri::XML(object) if object.is_a? String
      XMP::Document.new(object) if object.is_a? Nokogiri::XML::Document and object.root
    end
  end
end