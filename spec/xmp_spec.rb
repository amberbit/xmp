# encoding: UTF-8
require './spec/spec_helper.rb'

describe XMP do
  describe "with xmp.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp.xml')) }

    it "should return all namespace names" do
      @xmp.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
    end

    it "should return standalone attribute" do
      @xmp.dc.title.should eq(['Tytuł zdjęcia'])
      @xmp.dc.subject.should eq(['Słowa kluczowe i numery startowe.'])
      @xmp.photoshop.SupplementalCategories.should eq(['Nazwa imprezy'])
    end

    it "should return embedded attribute" do
      @xmp.Iptc4xmpCore.Location.should eq('Miejsce')
      @xmp.photoshop.Category.should eq('Kategoria')
    end

    it "should raise NoMethodError on unknown attribute" do
      lambda { @xmp.photoshop.UnknownAttribute }.should raise_error(NoMethodError)
    end

    describe "namespace 'tiff'" do
      before { @namespace = @xmp.tiff }

      it "should return all attribute names" do
        @namespace.attributes.should =~ %w{Make Model ImageWidth ImageLength XResolution YResolution ResolutionUnit}
      end
    end

    describe "namespace 'photoshop'" do
      before { @namespace = @xmp.photoshop }

      it "should return all attribute names" do
        @namespace.attributes.should =~ %w{LegacyIPTCDigest Category SupplementalCategories}
      end
    end
  end

  describe "with xmp2.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp2.xml')) }

    it "should return all namespace names" do
      @xmp.namespaces.should =~ %w{dc iX pdf photoshop rdf tiff x xap xapRights}
    end

    it "should return standalone attribute" do
      @xmp.dc.creator.should eq(['BenjaminStorrier'])
      @xmp.dc.subject.should eq(['SAMPLEkeyworddataFromIview'])
    end

    it "should return embedded attribute" do
      @xmp.photoshop.Headline.should eq('DeniseTestImage')
      @xmp.photoshop.Credit.should eq('Remco')
    end
  end
end
