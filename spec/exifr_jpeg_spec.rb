require './spec/spec_helper.rb'
require 'exifr/jpeg'

describe "XMP with EXIFR::JPEG" do
  it "should parse image given as path" do
    xmp = XMP.parse('spec/fixtures/multiple-app1.jpg')
    xmp.should be_instance_of(XMP::Document)
    xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end

  it "should parse image given as path with upper case extension" do
    xmp = XMP.parse('spec/fixtures/UPPERCASE.JPG')
    xmp.should be_instance_of(XMP::Document)
    xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end

  it "should parse image given as EXIFR::JPEG" do
    img = EXIFR::JPEG.new('spec/fixtures/multiple-app1.jpg')
    xmp = XMP.parse(img)
    xmp.should be_instance_of(XMP::Document)
    xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
  end

  it "should return nil for an image without XMP metadata" do
    xmp = XMP.parse('spec/fixtures/no-xmp-metadata.jpg')
    xmp.should be_nil
  end
end
