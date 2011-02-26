$LOAD_PATH.unshift 'lib'
require 'xmp/silencer'

XMP::Silencer.silently {
  require 'bundler/setup'
  Bundler.require(:development)
}

# load whole montgomery after bundler loads required gems
require 'xmp'

require 'pp'
