actions :run

attribute :address, :kind_of => String, :name_attribute => true
attribute :node_name, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :run_list, :kind_of => Array
attribute :protocol, :kind_of => Symbol, :equal_to => [:ssh, :winrm], :default => :ssh
attribute :sudo, :kind_of => [TrueClass, FalseClass], :default => false
attribute :cwd, :kind_of => String
attribute :environment, :kind_of => String
attribute :returns, :kind_of => Array, :default => [0]

def initialize(*args)
  super
  @action = :run
end