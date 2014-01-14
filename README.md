knife Cookbook
==============
This cookbook aims to provide knife functionality in cookbook form. This is particularly useful for multi-node configuration.

Requirements
------------
None

Providers
-----
#### knife_bootstrap

    knife_bootstrap 'mycomputer.mydomain.com' do
       node_name  'server1'                     # :kind_of => String
       username   'administrator'               # :kind_of => String
       password   'p@ssw0rd'                    # :kind_of => String
       run_list   ['recipe[apache]']            # :kind_of => Array
       protocol   :ssh                          # :kind_of => Symbol, :equal_to => [:ssh, :winrm], :default => :ssh
       sudo       true                          # :kind_of => [TrueClass, FalseClass], :default => false
       cwd        '/my/knife/directory/.chef'   # :kind_of => String  --> your knife directory (to load your knife settings)
       environment '_default'                   # :kind_of => String
       returns     [0]                          # :kind_of => Array, :default => [0]
       action :run
    end

#### knife_ssh
    knife_ssh 'run chef client on server1' do
        search_query 'name:server1 AND chef_environment:_default'   # :kind_of => String
        username 'user'                                             # :kind_of => String
        password 'p@ssw0rd'                                         # :kind_of => String
        command 'sudo chef-client'                                  # :kind_of => String
        protocol :ssh                                               # :kind_of => Symbol, :equal_to => [:ssh, :winrm], :default => :ssh
        attribute 'ipaddress'                                       # :kind_of => String
                                                                    # --> equivalent to -a option
        cwd  '/my/knife/directory/.chef'                            # :kind_of => String
        returns [0]                                                 # :kind_of => Array, :default => [0]
        transport_options nil                                       # :kind_of => Hash
                                                                    # --> to allow delegation of credentials with winrm use { :allow_delegate => true }. This is only supported on windows
        action :run
    end

#### knife_chef_run

    knife_chef_run 'run apache recipe on server1' do
        search_query 'name:server1'                     # :kind_of => String
        username 'user'                                 # :kind_of => String
        password 'p@ssw0rd'                             # :kind_of => String
        run_list ['role[webserver]', 'recipe[apache]']  # :kind_of => Array
        environment '_default'                          # :kind_of => String
        sudo true                                       # :kind_of => [TrueClass, FalseClass], :default => false
        attribute 'ipaddress'                           # :kind_of => String
                                                        # --> equivalent to -a option
        cwd '/my/knife/directory/.chef'                 # :kind_of => String
        returns [0]                                     # :kind_of => Array, :default => [0]
        protocol :ssh                                   # :kind_of => Symbol, :equal_to => [:ssh, :winrm], :default => :ssh
        transport_options nil                           # :kind_of => Hash
                                                        # --> to allow delegation of credentials with winrm use { :allow_delegate => true }. This is only supported on windows
    end
