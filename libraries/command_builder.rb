module KnifeCookbook
  class CommandBuilder
    #def arg_separator
    #  ' '
    #end

    def serialize_args
      serialized = arg_hash.map { |k, v| "#{k}#{v}" }.join(' ')
      serialized ? " #{serialized}" : nil
    end
  end
end