require_relative 'command_builder'

module KnifeCookbook
  class WinrmHelper < CommandBuilder
    def initialize(new_resource, query = nil)
      @resource = new_resource
      @query = query || ::Chef::Search::Query.new()
    end

    def commands
      nodes = search(:node, @resource.search_query)
      nodes.map { |n| WinrsCommand.new(n[attribute], @resource)}
    end

    private

    def attribute
      @resource.attribute || 'fqdn'
    end

    def search(type, query="*:*")
      @query.search(type, query)[0]
    end

    class WinrsCommand < CommandBuilder
      def initialize(address, resource)
        @address = address
        @resource = resource
        @password_flag = '-p'
      end

      def to_s
        format_command
      end

      def obscure
        @obscure = true
        command = format_command
        @obscure = false
        command
      end

      protected
      def format_arg(key, value)
        formatted_value = value
        if key == format_key_value_arg(@password_flag) && @obscure
          formatted_value = '********'
        end
        super(key, formatted_value)
      end

      def format_key_value_arg(arg)
        return "#{arg}#{arg_separator}"
      end

      def arg_separator
        ':'
      end

      private
      def format_command
        "winrs -r:http://#{@address}:5985#{serialize_args} #{@resource.command}"
      end

      def arg_hash
        args = Hash.new
        args[format_key_value_arg('-u')] = @resource.username if @resource.username
        args[format_key_value_arg(@password_flag)] = @resource.password if @resource.password
        args['-ad'] = nil if @resource.transport_options != nil && @resource.transport_options[:allow_delegate]
        args
      end
    end
  end
end
