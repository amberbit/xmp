require 'xmp/silencer'
XMP::Silencer.silently { require 'nokogiri' }
require 'xmp/namespace'

class XMP
  # underlying XML content
  attr_reader :xml
  # available namespace names
  attr_reader :namespaces

  # accepts valid XMP XML
  def initialize(xml)
    doc = Nokogiri::XML(xml)
    @xml = doc.root

    available_namespaces = doc.collect_namespaces
    # let nokogiri know about all namespaces
    available_namespaces.each do |ns, url|
      @xml.add_namespace_definition ns, url
    end

    # collect namespace names
    @namespaces = available_namespaces.collect do |ns, _|
      ns =~ /^xmlns:(.+)/
      $1
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
    namespaces.include?(namespace.to_s)
  end
end
