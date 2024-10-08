# encoding: UTF-8

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

    it "should respond to standalone attributes" do
      @xmp.should respond_to(:dc)
      @xmp.dc.should respond_to(:title)
      @xmp.should respond_to(:photoshop)
      @xmp.photoshop.should respond_to(:SupplementalCategories)
      @xmp.photoshop.should respond_to(:supplemental_categories)
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

    it "should raise if an attribute is called with any argument" do
      lambda { XMP.new('spec/fixtures/xmp.xml').dc('Comics') }.
        should raise_error(ArgumentError, "wrong number of arguments (given 1, expected 0)")
      lambda { XMP.new('spec/fixtures/xmp.xml').dc.title('Amazing Stories') }.
        should raise_error(ArgumentError, "wrong number of arguments (given 1, expected 0)")
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

  # metadata after lightroom 10 with face recognition
  describe "with xmp5.xml" do
    before { @xmp = XMP.new(File.read('spec/fixtures/xmp5.xml')) }

    it "should return dc:format" do
      @xmp.dc.format.should eq('image/jpeg')
    end

    it "should be able to read all attribute" do
      @xmp.to_h.keys.should =~ %w{Iptc4xmpExt aux crs dc exifEX mwg-rs photoshop rdf stArea stDim stEvt stRef x xmp xmpMM}
    end
  end

  it "should read from an IO" do
    xmp = XMP.new(File.open('spec/fixtures/xmp.xml'))
    xmp.namespaces.should =~ %w{rdf x tiff exif xap aux Iptc4xmpCore photoshop crs dc}
  end

  it "should raise if the file doesn't exist" do
    nonexistent_file = 'nonexistent.xml'
    lambda { XMP.new(nonexistent_file) }.should raise_error(XMP::Error, "cannot read file #{nonexistent_file}")
  end

  it "should return nil for an unknown attribute" do
    xmp = XMP.new('spec/fixtures/xmp-with-empty-attribute.xml')
    lambda { xmp.Iptc4xmpCore.CreatorContactInfo }.
      should raise_error(XMP::Error, "Don't know how to handle: \n<Iptc4xmpCore:CreatorContactInfo/>")
  end

  it "should raise for an unknown input type" do
    lambda { XMP.new(0) }.should raise_error(XMP::Error, "cannot handle 0")
  end
end
