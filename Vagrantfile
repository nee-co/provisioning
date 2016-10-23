required_plugins = %w{
  sahara
}

boxes = [
  {
    hostname: 'master',
    box: 'bento/centos-7.2',
    url: 'file:///C:/Users/Public/boxes/opscode_centos-7.2_chef-provisionerless.box',
  },
  {
    hostname: 'kevin.minions',
    box: 'bento/ubuntu-16.04',
    url: 'file:///C:/Users/Public/boxes/opscode_ubuntu-16.04_chef-provisionerless.box',
  },
  {
    hostname: 'stuart.minions',
    box: 'bento/ubuntu-14.04',
    url: 'file:///C:/Users/Public/boxes/opscode_ubuntu-14.04_chef-provisionerless.box',
  },
]

required_plugins.each do |plugin|
  system "vagrant plugin install #{plugin}" unless Vagrant.has_plugin? plugin
end

Vagrant.configure(2) do |config|
  config.vm.box_check_update = false

    boxes.each.with_index do |opts, num|
      config.vm.define opts[:hostname] do |node|
        node.vm.network :private_network, ip: "172.16.#{num}.18"
        node.vm.box = opts[:box]
        node.vm.box_url = opts[:url]
        node.vm.hostname = opts[:hostname]
      end
    end

  config.vm.provider :virtualbox do |vbox|
    vbox.memory = ENV['VBOX_MEMORY'] || 480
    vbox.cpus = ENV['VBOX_CPUS'] || 2
    vbox.customize ["modifyvm", :id, "--nictype1", "virtio"]
    vbox.customize ["modifyvm", :id, "--nictype2", "virtio"]
  end
end