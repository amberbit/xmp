# xmp - Extensible Metadata Platform (XMP) parser

MP provides object oriented interface to [XMP data](http://en.wikipedia.org/wiki/Extensible_Metadata_Platform). XMP data can be found in PDF, JPEG, GIF, PNG, and many other formats.

## Supported Formats

Format    | File extension  | Additional dependency
----------|-----------------|-----------------------
JPEG      | .jpeg, .jpg     | [exifr/jpeg](https://github.com/remvee/exifr)
TIFF      | .tiff, .tif     | [exifr/tiff](https://github.com/remvee/exifr)
XMP Files | .xmp, .xml      | none

## Usage

``` ruby
require 'xmp'
xmp = XMP.new('example.jpg')
xmp.dc.subject # => ["something interesting"]

xmp.namespaces.each do |namespace|
  xmp[namespace].attributes.each do |attribute|
    puts "#{namespace}.#{attribute}: #{xmp[namespace][attribute].inspect}"
  end
end
```

`XMP.new` accepts:
* Paths to files (it will choose based on file extension)
* File objects (it will choose based on file extension)
* Nokogiri documents or XML strings

Attributes can be accessed in the following ways:

``` ruby
# assuming an XMP entry AttributeName within the NamespaceName namespace, these are all equivalent
xmp['NamespaceName']['AttributeName']
xmp.namespace_name.attribute_name
xmp.NamespaceName.AttributeName

# you can also mix them
xmp.namespace_name['AttributeName']

# or convert the data to an actual hash
xmp.to_h # => { 'NamespaceName' => { … }, … }
```

## Installation

``` shell
$ gem install xmp
$ gem install exifr # optional, for jpeg/tiff support
```

Or you can add it to your Gemfile:

``` ruby
gem 'xmp',   '~> 1.0'
gem 'exifr', '~> 1.3'
```

## Requirements
* Ruby 2 or Ruby 3
* Nokogiri (1.10 or newer, gem dependency - will be installed automatically)
* EXIFR (1.3 or newer) - optional

## Development

Fork it at https://github.com/amberbit/xmp

``` shell
$ bundle install # install development dependencies
$ rake spec      # run specs
```

## License
Ruby's license.

Copyright (c) 2011 Wojciech Piekutowski, AmberBit (<http://amberbit.com>) and contributors.
