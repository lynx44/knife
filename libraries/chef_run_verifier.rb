module KnifeCookbook
  module ChefRunVerifier
    def verify_output(stdout, stderr)
      raise 'An error occurred when running the chef command' if contains_error(stdout) || contains_error(stderr)
    end

    private
    def contains_error(str)
      str =~ /FATAL:/ || str =~ /'chef-client' is not recognized/
    end
  end
end