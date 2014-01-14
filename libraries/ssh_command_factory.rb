require_relative('ssh_helper')
require_relative('winrm_helper')

module KnifeCookbook
  class SshCommandFactory
    def initialize
    end

    def create(resource)
      resource.protocol == :winrm && resource.transport_options && resource.transport_options[:allow_delegate] ?
          KnifeCookbook::WinrmHelper.new(resource) :
          KnifeCookbook::SshHelper.new(resource)
    end
  end
end
