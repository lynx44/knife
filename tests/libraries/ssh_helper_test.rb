require 'test/unit'
require "rspec/mocks/standalone"
require_relative('../../libraries/ssh_helper')

class SshHelperTest < Test::Unit::TestCase
  attr_accessor :helper

  def setup
    RSpec::Mocks::setup(self)
    self.setup_resource
    self.setup_helper
  end

  def setup_helper
    @helper = KnifeCookbook::SshHelper.new(@new_resource)
  end

  def helper
    @helper
  end

  def setup_resource
    @new_resource = double()
    @new_resource.stub(:protocol => :ssh)
    @new_resource.stub(:command)
    @new_resource.stub(:search_query)
    @new_resource.stub(:username)
    @new_resource.stub(:password)
    @new_resource.stub(:attribute)
    @new_resource.stub(:port)
  end

  def setup_logger
    logger = double()
    logger.stub(:debug)
    logger.stub(:info)

    return logger
  end

  def test_get_command_when_method_ssh_specifies_ssh
    @new_resource.stub(:method => :ssh)

    result = helper.commands.first.to_s

    assert_match('knife ssh', result)
  end

  def test_get_command_when_method_winrm_specifies_winrm
    @new_resource.stub(:protocol => :winrm)

    result = helper.commands.first.to_s

    assert_match('knife winrm', result)
  end

  def test_get_command_includes_search_query
    expectedSearchQuery = 'role:name'
    @new_resource.stub(:search_query => expectedSearchQuery)

    result = helper.commands.first.to_s

    assert_match(/knife [\w]+ \"#{expectedSearchQuery}\"/, result)
  end

  def test_get_command_includes_command
    expectedCommand = 'dir'
    @new_resource.stub(:command => expectedCommand)

    result = helper.commands.first.to_s

    assert_match(/knife [\w\s\"]+ \"#{expectedCommand}\"/, result)
  end

  def test_get_command_includes_username
    expectedUsername = 'user'
    @new_resource.stub(:username => expectedUsername)

    result = helper.commands.first.to_s

    assert_match(/knife [\w\s\"]+ -x \"#{expectedUsername}\"/, result)
  end

  def test_get_command_includes_password
    expectedPassword = 'user'
    @new_resource.stub(:password => expectedPassword)

    result = helper.commands.first.to_s

    assert_match(/knife [\w\s\"]+ -P \"#{expectedPassword}\"/, result)
  end

  def test_get_command_includes_attribute
    expectedAttribute = 'ipaddress'
    @new_resource.stub(:attribute => expectedAttribute)

    result = helper.commands.first.to_s

    assert_match(/knife [\w\s\"]+ -a #{expectedAttribute}/, result)
  end

  def test_obscured_command_censors_password
    @new_resource.stub(:password => 'password')

    result = helper.commands.first.obscure

    assert_match(/knife [\w\s\"]+ -P [*]{8}/, result)
  end

  def test_port_when_specified
    expectedPort = 123
    @new_resource.stub(:port => expectedPort)

    result = helper.commands.first.obscure

    assert_match(/knife [\w\s\"]+ -p #{expectedPort}/, result)
  end
end
