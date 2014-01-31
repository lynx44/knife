include Chef::Mixin::ShellOut
include KnifeCookbook::ChefRunVerifier

action :run do
  Chef::Log.debug("transport_options = #{@new_resource.transport_options}")
  cwd = @new_resource.cwd
  timeout = @new_resource.timeout

  Chef::Log.debug("helper type = #{helper.class}")
  returns_val = @new_resource.returns
  helper.commands.each do |command|
    Chef::Log.info(command.obscure)
    result = shell_out!(command.to_s, { "cwd" => cwd, "returns" => returns_val, "timeout" => timeout })

    Chef::Log.info(result.stdout)
    Chef::Log.info(result.stderr)
    verify_output(result.stdout, result.stderr)
  end
end

private
def helper
  @helper ||= ssh_factory.create(@new_resource)
end

def ssh_factory
  @ssh_factory ||= KnifeCookbook::SshCommandFactory.new()
end