actions :run
default_action :run

attribute :description, :kind_of => String, :name_attribute => true
attribute :search_query, :kind_of => String
attribute :username, :kind_of => String
attribute :password, :kind_of => String
attribute :command, :kind_of => String
attribute :protocol, :kind_of => Symbol, :equal_to => [:ssh, :winrm], :default => :ssh
#attribute :verify_hostkey, :kind_of => [TrueClass, FalseClass], :default => true #--[no-]host-key-verify
attribute :attribute, :kind_of => String
attribute :cwd, :kind_of => String
attribute :returns, :kind_of => Array, :default => [0]
attribute :transport_options, :kind_of => Hash #  for winrm -> { :allow_delegate => true, :ssl => true }
attribute :timeout, :kind_of => Integer, :default => 600
attribute :port, :kind_of => Integer