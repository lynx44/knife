require_relative 'command_builder'

module KnifeCookbook
  class WinrmHelper < CommandBuilder
    def initialize(new_resource, query = nil)
      @@resource = new_resource
      @@query = query || ::Chef::Search::Query.new()
    end

    def commands
      nodes = search(:node, @@resource.search_query)
      nodes.map { |n| "winrs -r:http://#{n[attribute]}:5985#{serialize_args} #{@@resource.command}"}
    end

    private
    def arg_separator
      ':'
    end

    def arg_hash
      args = Hash.new
      args[format_key_value_arg('-u')] = @@resource.username if @@resource.username
      args[format_key_value_arg('-p')] = @@resource.password if @@resource.password
      args['-ad'] = nil if @@resource.transport_options != nil && @@resource.transport_options[:allow_delegate]
      args
    end

    def format_key_value_arg(arg)
      return "#{arg}#{arg_separator}"
    end

    def attribute
      @@resource.attribute || 'fqdn'
    end

    def search(type, query="*:*")
      @@query.search(type, query)[0]
    end
  end
end
