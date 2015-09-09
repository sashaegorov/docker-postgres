Vagrant.configure('2') do |config|
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
  # Change to any suitable Ubuntu box
  config.vm.box = 'ubuntu10'
  config.vm.network 'private_network', ip: '192.168.50.5'
  # Forvard PostgreSQL port
  config.vm.network :forwarded_port, guest: 5432, host: 5432
  config.vm.provision :docker do |d|
    d.pull_images 'debian:jessie'
  end
end
