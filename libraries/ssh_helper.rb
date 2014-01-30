require_relative 'command_builder'

module KnifeCookbook
  class SshHelper < CommandBuilder

    def initialize(resource)
      @resource = resource
    end

    def commands
      ["knife #{@resource.protocol} \"#{@resource.search_query}\" \"#{@resource.command}\"#{serialize_args}"]
    end

    private
    def arg_hash
      args = Hash.new
      args['-x '] = "\"#{@resource.username}\"" if @resource.username
      args['-P '] = "\"#{@resource.password}\"" if @resource.password
      args['-a '] = "#{@resource.attribute}" if @resource.attribute
      args
    end

    #def serialize_args(args)
    #  args.map{|k,v| "#{k} #{v}"}.join(' ')
    #end
  end
end
