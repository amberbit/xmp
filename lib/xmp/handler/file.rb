require 'pathname'

module XMP::Handler
  class File
    SUPPORTED = [String, Pathname, ::File]
    attr_reader :extensions, :callback

    def initialize(*extensions, &callback)
      @extensions = extensions
      @callback   = callback
    end

    def call(object)
      return unless SUPPORTED.any? { |c| c === object }
      return unless path = Pathname(object) and extensions.include? path.extname.downcase
      return callback.call(object) if object.is_a? IO
      return path.open(&callback)  if path.exist? and path.readable?
      raise XMP::Error, "cannot read file #{path}"
    end
  end
end