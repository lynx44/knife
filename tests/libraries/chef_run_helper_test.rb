require 'test/unit'
require "rspec/mocks/standalone"
require_relative('../../libraries/chef_run_helper')

class ChefRunHelperTest < Test::Unit::TestCase
  attr_accessor :helper

  def setup
    RSpec::Mocks::setup(self)
    self.setup_resource
    self.setup_helper
  end

  def setup_helper
    @helper = KnifeCookbook::ChefRunHelper.new(@new_resource)
  end

  def helper
    @helper
  end

  def setup_resource
    @new_resource = double()
    @new_resource.stub(:sudo => false)
    @new_resource.stub(:run_list)
    @new_resource.stub(:attribute)
    @new_resource.stub(:environment)
    @new_resource.stub(:search_query)
    @new_resource.stub(:username)
    @new_resource.stub(:password)
    @new_resource.stub(:cwd)
    @new_resource.stub(:returns)
    @new_resource.stub(:protocol)
    @new_resource.stub(:transport_options)
  end

  def setup_logger
    logger = double()
    logger.stub(:debug)
    logger.stub(:info)

    return logger
  end

  def test_command_appends_chef_client
    result = helper.ssh_params.command

    assert_equal('chef-client', result)
  end

  def test_command_sudo_appends_sudo_text
    @new_resource.stub(:sudo => true)
    self.setup_helper()

    result = helper.ssh_params.command

    assert_equal('sudo chef-client', result)
  end

  def test_command_appends_run_list
    recipe = 'recipe[test]'
    @new_resource.stub(:run_list => [recipe])
    self.setup_helper()

    result = helper.ssh_params.command

    assert_match("-o '#{recipe}'", result)
  end

  def test_command_appends_multiple_to_run_list
    recipe = 'recipe[test]'
    @new_resource.stub(:run_list => [recipe,recipe])
    self.setup_helper()

    result = helper.ssh_params.command

    assert_match("-o '#{recipe},#{recipe}'", result)
  end

  def test_attribute_defaults_to_fqdn
    assert_equal('fqdn', helper.ssh_params.attribute)
  end

  def test_attribute_returns_expected
    expected = 'ipaddress'
    @new_resource.stub(:attribute => expected)

    assert_equal(expected, helper.ssh_params.attribute)
  end

  def test_command_includes_environment
    expectedEnvironment = 'test'
    @new_resource.stub(:environment => expectedEnvironment)

    assert_match("-E #{expectedEnvironment}", helper.ssh_params.command)
  end

  def test_search_query_returns_expected
    expected = 'test'
    @new_resource.stub(:search_query => expected)

    assert_equal(expected, helper.ssh_params.search_query)
  end

  def test_username_returns_expected
    expected = 'test'
    @new_resource.stub(:username => expected)

    assert_equal(expected, helper.ssh_params.username)
  end

  def test_password_returns_expected
    expected = 'test'
    @new_resource.stub(:password => expected)

    assert_equal(expected, helper.ssh_params.password)
  end

  def test_cwd_returns_expected
    expected = 'test'
    @new_resource.stub(:cwd => expected)

    assert_equal(expected, helper.ssh_params.cwd)
  end

  def test_returns_returns_expected
    expected = [0]
    @new_resource.stub(:returns => expected)

    assert_equal(expected, helper.ssh_params.returns)
  end

  def test_method_returns_expected
    expected = :winrm
    @new_resource.stub(:protocol => expected)

    assert_equal(expected, helper.ssh_params.protocol)
  end

  def test_transport_options_returns_expected
    expected = { :allow_delegate => true }
    @new_resource.stub(:transport_options => expected)

    assert_equal(expected, helper.ssh_params.transport_options)
  end

  def test_timeout
    expected = 50
    @new_resource.stub(:timeout).and_return(expected)

    assert_equal(expected, helper.timeout)
  end
end