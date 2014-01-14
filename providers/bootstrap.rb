include Chef::Mixin::ShellOut

action :run do
  node_name = @new_resource.node_name
  nodes = search(:client, "name:#{node_name} NOT name:#{node.name}")
  Chef::Log.debug("Bootstrapping node: #{node_name}")
  if(nodes.length == 0)
    command = helper.build_command
    cwd = @new_resource.cwd
    returns_val = @new_resource.returns
    Chef::Log.info("#{cwd}>#{command}")
    result = shell_out!(command, { 'cwd' => cwd, "returns" => returns_val })
    Chef::Log.info(result.stdout)
    helper.verify_output(result.stdout, result.stderr)
  else
    Chef::Log.debug("Skipping bootstrap #{node_name} since client key already exists.")
  end
end

def helper
  @helper ||= KnifeCookbook::BootstrapHelper.new(@new_resource)
end