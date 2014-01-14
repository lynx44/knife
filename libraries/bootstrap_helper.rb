require_relative('chef_run_verifier')

module KnifeCookbook
  class BootstrapHelper
    include KnifeCookbook::ChefRunVerifier

    def initialize(resource)
      @new_resource = resource
    end

    def build_command
      protocol = @new_resource.protocol == :winrm ? ' windows winrm' : nil
      "knife bootstrap#{protocol} #{@new_resource.address} -x #{@new_resource.username} -P #{@new_resource.password} #{serialize_args}"
    end

    #def verify_output(stdout, stderr)
    #  raise 'An error occurred when running the chef command' if contains_error(stdout) || contains_error(stderr)
    #end

    private
    def build_arg_hash
      args = Hash.new
      args['-r'] = "'#{@new_resource.run_list.join(',')}'" if @new_resource.run_list
      args['-E'] = "#{@new_resource.environment}" if @new_resource.environment
      args['--sudo --use-sudo-password'] = nil if @new_resource.sudo
      args['-N'] = "\"#{@new_resource.node_name}\"" if @new_resource.node_name
      args
    end

    def serialize_args
      build_arg_hash.map{|k,v| "#{k} #{v}"}.join(' ')
    end

    #def contains_error(str)
    #  str =~ /FATAL:/ || str =~ /'chef-client' is not recognized/
    #end
  end
end
