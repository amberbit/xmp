require './spec/spec_helper.rb'
require 'exifr/tiff'

describe "XMP with EXIFR::TIFF" do
  it "should parse image given as path" do
    xmp = XMP.parse('spec/fixtures/multiple-app1.tiff')
    xmp.should be_instance_of(XMP::Document)
    xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end

  it "should parse image given as EXIFR::TIFF" do
    img = EXIFR::TIFF.new('spec/fixtures/multiple-app1.tiff')
    xmp = XMP.parse(img)
    xmp.should be_instance_of(XMP::Document)
    xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end
end
