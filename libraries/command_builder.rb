module KnifeCookbook
  class CommandBuilder
    def serialize_args
      serialized = arg_hash.map { |k, v| format_arg(k, v) }.join(' ')
      serialized ? " #{serialized}" : nil
    end

    protected
    def format_arg(key, value)
      "#{key}#{value}"
    end
  end
end