require 'test/unit'
require 'ostruct'
require 'rspec/mocks/standalone'
require_relative('../../libraries/bootstrap_helper')
require_relative('node_mock')

class TestBootstrapHelper < Test::Unit::TestCase
  def setup
    RSpec::Mocks::setup(self)
    setup_helper
  end

  def setup_helper
    @helper = KnifeCookbook::BootstrapHelper.new(setup_resource)
  end

  def setup_resource
    @new_resource = OpenStruct.new
    @new_resource
  end

  def helper
    @helper
  end

  def test_build_command_calls_knife_bootstrap
    assert_match(/^knife bootstrap/, helper.build_command)
  end

  def test_build_command_appends_username
    username = 'something'
    @new_resource.username = username

    assert_option("-x #{username}", helper.build_command)
  end

  def test_build_command_appends_password
    password = 'something'
    @new_resource.password = password

    assert_option("-P #{password}", helper.build_command)
  end

  def test_build_command_appends_sudo_args_when_sudo_true
    @new_resource.sudo = true
    assert_option('--sudo --use-sudo-password', helper.build_command)
  end

  def test_build_command_nodes_not_append_sudo_args_when_sudo_false
    @new_resource.sudo = false
    assert_no_option('--sudo --use-sudo-password', helper.build_command)
  end

  def test_build_command_appends_no_run_list_when_run_list_nil
    @new_resource.run_list = nil

    assert_no_option('-r', helper.build_command)
  end

  def test_build_command_appends_run_list_when_run_list_has_value
    run_list = ['role[a]', 'recipe[b]']
    @new_resource.run_list = run_list

    assert_option("-r '#{run_list.join(',')}'", helper.build_command)
  end

  def test_build_command_appends_no_node_when_node_not_specified
    node_name = nil
    @new_resource.node_name = node_name

    assert_no_option("-N \"#{node_name}\"", helper.build_command)
  end

  def test_build_command_appends_node_when_node_specified
    node_name = 'something'
    @new_resource.node_name = node_name

    assert_option("-N \"#{node_name}\"", helper.build_command)
  end

  def test_build_command_appends_no_environment_when_not_specified
    environment = nil
    @new_resource.environment = environment

    assert_no_option("-E #{environment}", helper.build_command)
  end

  def test_build_command_appends_environment_when_specified
    environment = 'test'
    @new_resource.environment = environment

    assert_option("-E #{environment}", helper.build_command)
  end

  def test_build_command_appends_address
    address = '192.168.1.1'
    @new_resource.address = address

    assert_option(address, helper.build_command)
  end

  def test_build_command_appends_windows_winrm_when_method_winrm
    @new_resource.protocol = :winrm

    assert_match(/^knife bootstrap windows winrm/, helper.build_command)
  end

  def test_verify_output_ignores_if_fatal_not_found
    assert_nothing_raised do
      helper.verify_output('chef run complete', nil)
    end
  end

  def test_verify_output_if_fatal_not_found
    assert_raise_message 'An error occurred when running the chef command' do
      helper.verify_output('FATAL:', nil)
    end
  end

  def test_verify_output_if_chef_client_not_found
    assert_raise_message 'An error occurred when running the chef command' do
      helper.verify_output("'chef-client' is not recognized'", nil)
    end
  end

  private
  def assert_option(option, command)
    option.gsub!('[', '\\[')
    option.gsub!(']', '\\]')
    assert_match(/^knife bootstrap[\s\w-]*#{option}/, command)
  end

  def assert_no_option(option, command)
    option.gsub!('[', '\\[')
    option.gsub!(']', '\\]')
    assert_no_match(/^knife bootstrap[\s\w-]*#{option}/, command)
  end
end
