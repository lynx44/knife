include Chef::Mixin::ShellOut
require 'net/ssh'

action :trigger do
  helper = KnifeCookbook::ChefRunHelper.new(@new_resource)

  knife_ssh @new_resource.description do
    search_query helper.ssh_params.search_query
    command helper.ssh_params.command
    username helper.ssh_params.username
    password helper.ssh_params.password
    attribute helper.ssh_params.attribute
    cwd helper.ssh_params.cwd
    protocol helper.ssh_params.protocol
    returns helper.ssh_params.returns
    transport_options helper.ssh_params.transport_options
    timeout helper.timeout
  end
end
