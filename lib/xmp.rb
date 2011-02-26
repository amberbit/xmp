require 'xmp/silencer'
XMP::Silencer.silently { require 'nokogiri' }
require 'xmp/namespace'

class XMP
  # underlying XML content
  attr_reader :xml

  # accepts valid XMP XML
  def initialize(xml)
    doc = Nokogiri::XML(xml)
    @xml = doc.root
    @namespaces = doc.collect_namespaces

    # add all namespaces
    @namespaces.each do |ns, url|
      @xml.add_namespace_definition ns, url
    end
  end

  # if it's a valid namespace return a namespace proxy object, else call
  # other method
  def method_missing(namespace, *args)
    if has_namespace?(namespace)
      Namespace.new(self, namespace)
    else
      super
    end
  end

  def respond_to?(method)
    has_namespace?(method) or super
  end

  private

  def has_namespace?(namespace)
    @namespaces.has_key?("xmlns:#{namespace}")
  end
end
