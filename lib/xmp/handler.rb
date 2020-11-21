module XMP::Handler
  attr_accessor :handlers

  def new(object)
    last_error = nil
    result     = object

    handlers.each do |handler|
      begin
        next unless new_result = handler.call(result)
        return new_result if new_result.is_a? XMP::Document
        result = new_result
      rescue XMP::Error => error
        last_error = error
      end
    end

    raise last_error if last_error
    raise XMP::Error, "cannot handle #{object.inspect}"
  end

  alias_method :parse, :new
end