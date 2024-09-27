class XMP::Document
  include XMP::Convenience

  attr_reader :namespaces
  attr_reader :xml

  def initialize(doc = nil)
    if doc
      @xml = doc.root
      @namespaces = doc.collect_namespaces.map do |ns, url|
        @xml.add_namespace_definition ns, url
        ns[/^(?:xmlns:)?xmlns:(.+)/, 1]
      end
    else
      @xml = nil
      @namespaces = []
    end
  end

  private

  def list
    namespaces
  end

  def get(key)
    XMP::Namespace.new(self, key)
  end
end