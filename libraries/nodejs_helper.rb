module NodeJs
  module Helper
    def npm_dist
      if node['nodejs']['npm']['url']
        return { 'url' => node['nodejs']['npm']['url'] }
      else

        require 'open-uri'
        require 'json'
        result = JSON.parse(URI.parse("https://registry.npmjs.org/npm/#{node['nodejs']['npm']['version']}").read)
        ret = { 'url' => result['dist']['tarball'], 'version' => result['_npmVersion'], 'shasum' => result['dist']['shasum'] }
        Chef::Log.debug("Npm dist #{ret}")
        return ret
      end
    end

    def install_not_needed?
      cmd = Mixlib::ShellOut.new("#{node['nodejs']['node_bin']} --version")
      version = cmd.run_command.stdout.chomp
      ::File.exist?("#{node['nodejs']['dir']}/bin/node") && version == "v#{node['nodejs']['version']}"
    end
  end
end