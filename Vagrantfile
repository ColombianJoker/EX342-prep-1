require 'fileutils'

Vagrant.configure("2") do |config|

  vms = [
    { name: "ansible-control", ip: "192.168.56.10", mem: "2048", cpus: "2" },
    { name: "ansible2", ip: "192.168.56.12", mem: "2048", cpus: "1" },
    { name: "ansible3", ip: "192.168.56.13", mem: "2048", cpus: "1" },
    { name: "ansible4", ip: "192.168.56.14", mem: "2048", cpus: "1" },
    { name: "ansible5", ip: "192.168.56.15", mem: "2048", cpus: "1", disk: true }
  ]

  vms.each do |opts|
    config.vm.define opts[:name] do |node|
      node.vm.box = "bento/almalinux-9"
      node.vm.box_version = "202511.24.0"
      
      node.vm.hostname = "#{opts[:name]}.hl.local"
      node.ssh.password = "vagrant"
      node.ssh.forward_agent = true

      node.vm.network "private_network", ip: opts[:ip]

      node.vm.provider "vmware_desktop" do |vmw|
        vmw.memory = opts[:mem]
        vmw.vmx["numvcpus"] = opts[:cpus]
        # Removed the hardcoded ethernet0.pcislotnumber to prevent interface collisions
        
        if opts[:disk]
          disk_path = File.expand_path(".vagrant/machines/#{opts[:name]}/vmware_desktop/#{opts[:name]}_disk2.vmdk")
          
          vmw.vmx["scsi0:1.present"] = "TRUE"
          vmw.vmx["scsi0:1.fileName"] = disk_path
        end
      end

      if opts[:disk]
        node.trigger.before :up do |trigger|
          trigger.name = "Creating 1GB disk for #{opts[:name]}"
          trigger.ruby do |env, machine|
            disk_path = File.expand_path(".vagrant/machines/#{opts[:name]}/vmware_desktop/#{opts[:name]}_disk2.vmdk")
            disk_dir = File.dirname(disk_path)

            unless File.exist?(disk_path)
              puts "Creating 1GB virtual disk at #{disk_path}..."
              FileUtils.mkdir_p(disk_dir)
              vdiskmanager = "/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager"
              
              system("\"#{vdiskmanager}\" -c -s 1GB -a lsilogic -t 0 \"#{disk_path}\"")
            end
          end
        end
      end

      # Fix for AlmaLinux 9 DHCP/machine-id cloning bugs
      node.vm.provision "shell", inline: <<-SHELL
        echo "Fixing machine-id..."
        rm -f /etc/machine-id
        dbus-uuidgen --ensure=/etc/machine-id
        systemctl restart NetworkManager
        sleep 2
        ip -4 -o a
      SHELL
    end
  end
end
