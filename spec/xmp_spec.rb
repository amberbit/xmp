# encoding: UTF-8
require './spec/spec_helper.rb'

describe XMP do
  describe "with xmp.xml" do
    before { @xmp = XMP.new('spec/fixtures/xmp.xml') }

    it "should return all namespace names" do
      @xmp.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
    end

    it "should support converting to hash via to_h" do
      hash = @xmp.to_h
      hash.should be_a(Hash)
      hash['dc'].should be_a(Hash)
      hash.keys.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
      hash['dc'].keys.should =~ %w{creator title rights subject description}
      hash['dc']['title'].should eq(['Tytuł zdjęcia'])
    end

    it "should return standalone attribute" do
      @xmp.dc.title.should eq(['Tytuł zdjęcia'])
      @xmp.dc.subject.should eq(['Słowa kluczowe i numery startowe.'])
      @xmp.photoshop.SupplementalCategories.should eq(['Nazwa imprezy'])
      @xmp.photoshop.supplemental_categories.should eq(['Nazwa imprezy'])
      @xmp['photoshop']['SupplementalCategories'].should eq(['Nazwa imprezy'])
    end

    it "should return standalone attribute hash" do
      @xmp.Iptc4xmpCore.CreatorContactInfo.should eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end

    it "should return embedded attribute" do
      @xmp.Iptc4xmpCore.Location.should eq('Miejsce')
      @xmp.photoshop.Category.should eq('Kategoria')
    end

    it "should raise NoMethodError on unknown attribute" do
      lambda { @xmp.photoshop.UnknownAttribute }.should raise_error(NoMethodError)
      @xmp.photoshop['UnknownAttribute'].should eq(nil)
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

  # metadata after lightroom -> preview (resize)
  # this one has only standalone attributes
  describe "with xmp3.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp3.xml')) }

    it "should return attributes" do
      @xmp.Iptc4xmpCore.Location.should eq('Phạm Đình Hồ')
      @xmp.photoshop.City.should eq('Hanoi')
      @xmp.aux.Lens.should eq('EF24-105mm f/4L IS USM')
    end

    it "should return standalone attribute hash" do
      @xmp.Iptc4xmpCore.CreatorContactInfo.should eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end

  end

  # metadata after lightroom
  describe "with xmp4.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp4.xml')) }

    it "should return dc:format" do
      @xmp.dc.format.should eq('image/jpeg')
    end

    it "should return standalone attribute hash" do
      @xmp.Iptc4xmpCore.CreatorContactInfo.should eq({'CiAdrCtry' => 'Germany', 'CiAdrCity' => 'Berlin'})
    end


  end
end
