# xmp - Extensible Metadata Platform (XMP) parser

xmp gem provides object oriented interface to XMP data (http://en.wikipedia.org/wiki/Extensible_Metadata_Platform). XMP data can be found in PDF, JPEG, GIF, PNG, and many other formats.

## Supported formats

Currently only JPEG is supported through exifr gem.

## JPEG Example

    # gem install exifr
    img = EXIFR::JPEG.new('IMG_6841.JPG')
    xmp = XMP.parse(img)
    xmp.dc.subject #=> "something interesting"

## Installation

    gem install xmp

## Ruby version

Ruby 1.8.7 and 1.9.2 are supported.
