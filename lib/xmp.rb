require 'xmp/silencer'
XMP::Silencer.silently { require 'nokogiri' }
require 'xmp/namespace'

# = XMP XML parser
#
# == Example
#   xmp = XMP.new(File.read('xmp.xml'))
#   xmp.dc.title           # => "Amazing Photo"
#   xmp.photoshop.Category # => "summer"
#   xmp.photoshop.SupplementalCategories # => ["morning", "sea"]
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

  def inspect
    "#<XMP:@namespaces=#{@namespaces.inspect}>"
  end

  # returns Namespace object if namespace exists, otherwise tries to call a method
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
