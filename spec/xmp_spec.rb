# encoding: UTF-8
require './spec/spec_helper.rb'

describe XMP do
  subject { XMP.new(File.read('spec/fixtures/xmp.xml')) }

  it "should return all namespace names" do
    subject.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
  end

  it "should return standalone attribute" do
    subject.dc.title.should eq(['Tytuł zdjęcia'])
    subject.dc.subject.should eq(['Słowa kluczowe i numery startowe.'])
    subject.photoshop.SupplementalCategories.should eq(['Nazwa imprezy'])
  end

  it "should return embedded attribute" do
    subject.Iptc4xmpCore.Location.should eq('Miejsce')
    subject.photoshop.Category.should eq('Kategoria')
    subject.photoshop.UnknownAttribute.should be_nil
  end
end
