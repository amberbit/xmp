# xmp - Extensible Metadata Platform (XMP) parser

xmp gem provides object oriented interface to XMP data (http://en.wikipedia.org/wiki/Extensible_Metadata_Platform). XMP data can be found in PDF, JPEG, GIF, PNG, and many other formats.

## Supported formats

Currently only JPEG is supported through exifr gem.

## JPEG Example

    # gem install exifr
    img = EXIFR::JPEG.new('IMG_6841.JPG')
    xmp = XMP.parse(img)
    xmp.dc.subject #=> "something interesting"

    # explore XMP data
    xmp.namespaces.each do |namespace_name|
      namespace = xmp.send(namespace_name)
      namespace.attributes.each do |attr|
        puts "#{namespace_name}.#{attr}: " + namespace.send(attr).inspect
      end
    end

## Installation

    gem install xmp

## Ruby version

Ruby 1.8.7 and 1.9.2 are supported.
