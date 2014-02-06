require 'test/unit'
require 'rspec/mocks/standalone'
require 'ostruct'
require_relative('../../libraries/winrm_helper')

class WinrmHelperTest < Test::Unit::TestCase
  attr_accessor :helper

  def setup
    RSpec::Mocks::setup(self)
    self.setup_resource
    self.setup_query
    self.setup_helper
  end

  def setup_helper
    @helper = KnifeCookbook::WinrmHelper.new(@new_resource, @query)
  end

  def setup_resource
    @new_resource = double()
    @new_resource.stub(:search_query)
    @new_resource.stub(:username)
    @new_resource.stub(:password)
    @new_resource.stub(:attribute)
    @new_resource.stub(:command)
    @new_resource.stub(:transport_options => { :allow_delegate => false })
    @new_resource.stub(:port)
  end

  def setup_query
    @query = double()
    setup_nodes([{'fqdn' => '' }])
  end

  def setup_nodes(nodes)
    @query.stub(:search).with(:node, @new_resource.search_query).and_return([nodes, 0, 0])
  end

  def setup_logger
    logger = double()
    logger.stub(:debug)
    logger.stub(:info)

    return logger
  end

  def test_commands_calls_winrs
    result = @helper.commands.first.to_s

    assert_match('winrs', result)
  end

  def test_commands_specifies_address_with_fqdn_by_default
    uri = 'node.server.com'
    setup_nodes([{ 'fqdn' => uri }])
    result = @helper.commands.first.to_s

    assert_match("winrs -r:http://#{uri}:5985", result)
  end

  def test_commands_honors_specified_address_attribute
    @new_resource.stub(:attribute => 'ipaddress')
    uri = '192.168.1.44'
    setup_nodes([{ @new_resource.attribute => uri }])
    result = @helper.commands.first.to_s

    assert_match("winrs -r:http://#{uri}:5985", result)
  end

  def test_commands_specifies_username
    expectedUsername = 'user'
    @new_resource.stub(:username => expectedUsername)
    result = @helper.commands.first.to_s

    assert_match(/-u:#{expectedUsername}/, result)
  end

  def test_commands_specifies_password
    expectedPassword = 'password'
    @new_resource.stub(:password => expectedPassword)
    result = @helper.commands.first.to_s

    assert_match(/-p:#{expectedPassword}/, result)
  end

  def test_commands_specifies_command
    expectedCommand = 'chef-client'
    @new_resource.stub(:command => expectedCommand)
    result = @helper.commands.first.to_s

    assert_match(/#{expectedCommand}$/, result)
  end

  def test_commands_specifies_allow_delegate
    @new_resource.stub(:transport_options => { :allow_delegate => true })
    result = @helper.commands.first.to_s

    assert_match(/-ad/, result)
  end

  def test_commands_nil_transport_options
    @new_resource.stub(:transport_options => nil)
    result = @helper.commands.first.to_s

    assert_false(result.include?('-ad'))
  end

  def test_commands_transport_options_without_option_ignores
    @new_resource.stub(:transport_options => { :something => true })
    result = @helper.commands.first.to_s

    assert_false(result.include?('-ad'))
  end

  def test_commands_returns_command_for_each_node_found
    setup_nodes([{'fqdn' => 'server1.com'}, {'fqdn' => 'server2.com'}])

    assert_equal(2, @helper.commands.length)
  end

  def test_obscured_command_censors_password
    @new_resource.stub(:password => 'password')

    result = @helper.commands.first.obscure

    assert_match(/-p:[*]{8}/, result)
  end

  def test_ssl_option_uses_https
    @new_resource.stub(:transport_options => { :ssl => true })

    result = @helper.commands.first.to_s

    assert_match(/https:[\/]{2}/, result)
  end

  def test_port
    port = 123
    @new_resource.stub(:port => port)

    result = @helper.commands.first.to_s

    assert_match(/http:[\/]{2}[\w.-]*:#{port}/, result)
  end
end
