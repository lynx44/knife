require 'ostruct'

module KnifeCookbook
  class ChefRunHelper

    def initialize(resource)
      @@resource = resource
    end

    def ssh_params
      struct = OpenStruct.new
      struct.command = build_command
      struct.attribute = @@resource.attribute || 'fqdn'
      struct.search_query = @@resource.search_query
      struct.username = @@resource.username
      struct.password = @@resource.password
      struct.cwd = @@resource.cwd
      struct.returns = @@resource.returns
      struct.protocol = @@resource.protocol
      struct.transport_options = @@resource.transport_options
      struct
    end

    private
    def build_command
      chef_client_command = 'chef-client'
      args = build_arg_hash
      cmdargs = serialize_args(args)
      space = cmdargs == '' ? '' : ' '
      base_command = @@resource.sudo ? "sudo #{chef_client_command}" : chef_client_command
      "#{base_command}#{space}#{cmdargs}"
    end

    def build_arg_hash
      args = Hash.new
      args['-o'] = "'#{@@resource.run_list.join(',')}'" if @@resource.run_list
      args['-E'] = "#{@@resource.environment}" if @@resource.environment
      args
    end

    def serialize_args(args)
      args.map{|k,v| "#{k} #{v}"}.join(' ')
    end
  end
end
