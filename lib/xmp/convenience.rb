module XMP::Convenience
  def include?(key)
    key_map.include? key
  end

  def [](key)
    return unless key = key_map[key]
    @entries      ||= {}
    @entries[key] ||= get(key)
  end

  def respond_to_missing?(method_name, include_private = false)
    include?(key) or super
  end

  def to_h
    list.map do |key|
      result = self[key]
      result = result.to_h if result.is_a? XMP::Convenience
      [key, result]
    end.to_h
  end

  private

  def method_missing(method_name, *arguments, &block)
    return super unless include? method_name
    raise ArgumentError, "wrong number of arguments (given #{arguments.size}, expected 0)" if arguments.any?
    self[method_name]
  end

  def key_map
    @key_map ||= list.inject({}) do |map, key|
      underscore_key = key.gsub(/([a-z])([^a-z])|(\d)(\D)|(\D)(\d)/, '\1\3\5_\2\4\6').tr('-', '_').downcase
      map.merge!(key => key, key.to_sym => key, underscore_key => key, underscore_key.to_sym => key)
    end
  end
end