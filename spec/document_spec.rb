describe XMP::Document do
  describe '.new' do
    it "should convert a Nokogiri::XML::Document to an XMP::Document with the expected XML and namespaces" do
      xml_doc = Nokogiri::XML(File.open('spec/fixtures/xmp.xml'))
      xmp_doc = XMP::Document.new(xml_doc)
      xmp_doc.xml.should eq(xml_doc.root)
      xmp_doc.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
      xmp_doc.should_not be_empty
    end

    it "should, given no args, create an empty XMP::Document" do
      xmp_doc = XMP::Document.new
      xmp_doc.xml.should be_nil
      xmp_doc.namespaces.should be_empty
      xmp_doc.should be_empty
    end
  end
end
