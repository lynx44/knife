require_relative 'command_builder'

module KnifeCookbook
  class SshHelper

    def initialize(resource)
      @resource = resource
    end

    def commands
      [SshCommand.new(@resource)]
    end
  end

  class SshCommand < CommandBuilder
    def initialize(resource)
      @resource = resource
      @password_flag = '-P '
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
      if key == @password_flag && @obscure
        formatted_value = '********'
      end
      super(key, formatted_value)
    end

    private
    def format_command
      "knife #{@resource.protocol} \"#{@resource.search_query}\" \"#{@resource.command}\"#{serialize_args}"
    end

    def arg_hash
      args = Hash.new
      args['-x '] = "\"#{@resource.username}\"" if @resource.username
      args[@password_flag] = "\"#{@resource.password}\"" if @resource.password
      args['-a '] = "#{@resource.attribute}" if @resource.attribute
      args
    end
  end
end
