require_relative('ssh_helper')
require_relative('winrm_helper')

module KnifeCookbook
  class SshCommandFactory
    def initialize
    end

    def create(resource)
      resource.protocol == :winrm && use_winrm(resource) ?
          KnifeCookbook::WinrmHelper.new(resource) :
          KnifeCookbook::SshHelper.new(resource)
    end

    private
    def use_winrm(resource)
      resource.transport_options && (resource.transport_options[:allow_delegate] || resource.transport_options[:ssl])
    end
  end
end
