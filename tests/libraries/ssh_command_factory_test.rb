require 'test/unit'
require 'rspec/mocks/standalone'
require_relative('../../libraries/ssh_command_factory')
require_relative('../../libraries/ssh_helper')
require_relative('../../libraries/winrm_helper')
require 'chef/search/query'

class SshCommandFactoryTest < Test::Unit::TestCase
  def setup
    RSpec::Mocks::setup(self)
    setup_resource
    setup_factory
  end

  def setup_resource
    @@new_resource = double()
    @@new_resource.stub(:search_query)
    @@new_resource.stub(:username)
    @@new_resource.stub(:password)
    @@new_resource.stub(:attribute)
    @@new_resource.stub(:command)
    @@new_resource.stub(:protocol)
    @@new_resource.stub(:transport_options => { :allow_delegate => false })
  end

  def setup_factory
    @@factory = KnifeCookbook::SshCommandFactory.new()
  end

  def test_create_returns_ssh_helper_by_default
    helper = @@factory.create(@@new_resource)

    assert_kind_of(KnifeCookbook::SshHelper, helper)
  end

  def test_create_returns_winrm_helper_when_allow_delegate_specified_and_method_is_winrm
    @@new_resource.stub(:transport_options => { :allow_delegate => true })
    @@new_resource.stub(:protocol => :winrm)
    helper = @@factory.create(@@new_resource)

    assert_kind_of(KnifeCookbook::WinrmHelper, helper)
  end
end