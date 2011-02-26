class XMP
  class Namespace # :nodoc:
    def initialize(xmp, namespace)
      @xmp = xmp
      @namespace = namespace
    end

    def inspect
      "#<XMP::Namespace:#{@namespace}>"
    end

    def method_missing(method, *args)
      embedded_attribute(method) || standalone_attribute(method)
    end

    private

    def embedded_attribute(name)
      description = xml.xpath('//rdf:Description').first
      attribute = description.attribute("#{name}")
      attribute ? attribute.text : nil
    end

    def standalone_attribute(name)
      attribute_xpath = "//#{@namespace}:#{name}"
      attribute = xml.xpath(attribute_xpath).first
      return unless attribute

      array_value = attribute.xpath("./rdf:Bag | ./rdf:Seq | ./rdf:Alt").first
      if array_value
        items = array_value.xpath("./rdf:li")
        items.map { |i| i.text }
      else
        raise "Don't know how to handle: \n" + attribute.to_s
      end
    end

    def xml
      @xmp.xml
    end
  end
end
