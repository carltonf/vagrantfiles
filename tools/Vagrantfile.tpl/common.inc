# -*- mode: ruby -*-
# vi: set ft=ruby :

def config_common(config)
  config.vm.box_check_update = false
  # NOTE No new keys s.t. easy access for non-host machines (only need vagrant key)
  config.ssh.insert_key = false
end

## NOTE Needed to work around a bug in VirtualBox dhcp server
# Ref: http://dipanjan.in/windows/virtualbox-runs-a-phantom-dhcp-server/
#
# Also, the builtin Vagrant's dhcp is hard-coded to "172.28.128.X". The
# following function allows to use dhcp on any specified host-only network.
#
## NOTE Use my own DHCP Server
#  For name resolution, I set
# up a custom dhcp server at crystal.cw (172.28.128.77), ranging from
# 172.28.128.100-254.
#
# Forced domain '.cv.' with crystal.cw as Authority, linked with bind.cw
def config_vm_network_private_network_dhcp(config, ip = "172.28.128.13", distro = "ubuntu")
    config.vm.network "private_network", ip: ip, auto_config: false
    # Ubuntu xenial
    case distro
    when "ubuntu" then
      config.vm.provision "shell", privileged: true, run: "always",
                          inline: "dhclient enp0s8"
    else
      puts "WARNING: private network not provisioned for " + $distro
    end
end
