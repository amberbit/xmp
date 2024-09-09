class XMP::Namespace
  include XMP::Convenience
  attr_reader :document, :namespace, :standalone_attributes, :embedded_attributes

  def initialize(document, namespace)
    @document, @namespace  = document, namespace
    @standalone_attributes = xml.xpath("//rdf:Description/#{namespace}:*").map(&:name)
    @embedded_attributes   = xml.xpath('//rdf:Description').flat_map do |description|
      description.attributes.values.select { |attr| attr.namespace.prefix.to_s == namespace }.map(&:name)
    end
  end
  
  def attributes
    @attributes ||= (standalone_attributes + embedded_attributes).uniq
  end

  private

  def xml
    document.xml
  end

  def list
    attributes
  end

  def get(name)
    embedded_attributes.include?(name) ? get_embedded(name) : get_standalone(name)
  end

  def get_embedded(name)  
    return unless element = xml.at("//rdf:Description[@#{namespace}:#{name}]")
    element.attribute(name.to_s).text
  end

  def get_standalone(name)
    return unless attribute = xml.xpath("//#{namespace}:#{name}").first
    if list = attribute.xpath("./rdf:Bag | ./rdf:Seq | ./rdf:Alt").first
      return list.xpath("./rdf:li").map(&:text)
    end

    hash = {}
    attribute.element_children.each { |c| hash[c.name] = c.text }
    attribute.attributes.each { |k, v| hash[k] = v.value } if hash.empty?
    return hash unless hash.empty?

    text = attribute.text.to_s.strip
    return text if text.length > 0

    raise XMP::Error, "Don't know how to handle: \n" + attribute.to_s
  end
end