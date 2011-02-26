class XMP
  class Namespace
    # available attributes
    attr_reader :attributes

    def initialize(xmp, namespace) # :nodoc
      @xmp = xmp
      @namespace = namespace.to_s

      @attributes = []
      embedded_attributes =
        xml.xpath("//rdf:Description").map { |d|
          d.attributes.values.
            select { |attr| attr.namespace.prefix.to_s == @namespace }.
            map(&:name)
        }.flatten
      @attributes.concat embedded_attributes
      standalone_attributes = xml.xpath("//rdf:Description/#{@namespace}:*").
                                  map(&:name)
      @attributes.concat standalone_attributes
    end

    def inspect
      "#<XMP::Namespace:#{@namespace}>"
    end

    def method_missing(method, *args)
      if has_attribute?(method)
        embedded_attribute(method) || standalone_attribute(method)
      else
        super
      end
    end

    def respond_to?(method)
      has_attribute?(method) or super
    end

    private

    def embedded_attribute(name)
      element = xml.at("//rdf:Description[@#{@namespace}:#{name}]")
      return unless element
      element.attribute(name.to_s).text
    end

    def has_attribute?(name)
      attributes.include?(name.to_s)
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
