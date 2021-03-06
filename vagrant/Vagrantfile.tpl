Vagrant.configure("2") do |config|
  ## Chose your base box
  config.vm.box = "aa_dev"

  config.vm.network :private_network, ip: "10.11.12.13"

  ## allocate 1GB memory by default
  config.vm.provider :virtualbox do |vb|
    vb.name = "appannie-dev"
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  ## do NOT auto update VirtualBox additions
  config.vbguest.auto_update = false

  ## For masterless, mount your salt file root
  config.vm.synced_folder "salt/roots/", "/srv/"
  config.vm.synced_folder local_aa_repo_file, "/services/appannie/aa"

  ## Use all the defaults:
  config.vm.provision :salt do |salt|

    salt.minion_config = "salt/minion"
    salt.run_highstate = true

  end
end
