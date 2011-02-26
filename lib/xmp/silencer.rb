class XMP
  module Silencer
    def self.silently
      verbosity = $VERBOSE
      $VERBOSE = nil
      result = yield
      $VERBOSE = verbosity
      result
    end
  end
end
