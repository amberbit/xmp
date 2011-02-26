class XMP
  class Namespace
    # available attributes
    attr_reader :attributes

    def initialize(xmp, namespace) # :nodoc
      @xmp = xmp
      @namespace = namespace.to_s

      @attributes = []
      @attributes.concat xml.at("//rdf:Description").attributes.values.
        select { |attr| attr.namespace.prefix.to_s == @namespace }.
        map(&:name)
      @attributes.concat xml.at("//rdf:Description").
                             xpath("./#{@namespace}:*").
                             map(&:name)
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
      description = xml.xpath('//rdf:Description').first
      attribute = description.attribute("#{name}")
      attribute ? attribute.text : nil
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
