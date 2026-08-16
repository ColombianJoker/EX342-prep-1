require 'fileutils'

Vagrant.configure("2") do |config|

  # Define the 5 nodes required for the practice exam with their static IPs
  vms = [
    { name: "ansible-control", ip: "192.168.56.10", mem: "2048", cpus: "2" },
    { name: "ansible2", ip: "192.168.56.12", mem: "2048", cpus: "1" },
    { name: "ansible3", ip: "192.168.56.13", mem: "2048", cpus: "1" },
    { name: "ansible4", ip: "192.168.56.14", mem: "2048", cpus: "1" },
    { name: "ansible5", ip: "192.168.56.15", mem: "2048", cpus: "1", disk: true }
  ]

  vms.each do |opts|
    config.vm.define opts[:name] do |node|
      # Using your validated AlmaLinux 9 box
      node.vm.box = "bento/almalinux-9"
      node.vm.box_version = "202511.24.0"
      
      node.vm.hostname = "#{opts[:name]}.hl.local"
      node.ssh.password = "vagrant"
      node.ssh.forward_agent = true

      # ONLY use a private network to avoid overloading VMware vmnet creation
      # This provides the static IPs necessary for the Ansible inventory
      node.vm.network "private_network", ip: opts[:ip]

      node.vm.provider "vmware_desktop" do |vmw|
        vmw.memory = opts[:mem]
        vmw.vmx["numvcpus"] = opts[:cpus]
        vmw.vmx["ethernet0.pcislotnumber"] = "160"

        # Attach 1GB secondary disk ONLY to ansible5.hl.local[span_2](start_span)[span_2](end_span)
        if opts[:disk]
          disk_path = File.expand_path(".vagrant/machines/#{opts[:name]}/vmware_desktop/#{opts[:name]}_disk2.vmdk")
          
          # Map it as SCSI so the OS sees it as /dev/sdb[span_3](start_span)[span_3](end_span)
          vmw.vmx["scsi0:1.present"] = "TRUE"
          vmw.vmx["scsi0:1.fileName"] = disk_path
        end
      end

      # Pre-boot trigger to create the 1GB disk for ansible5.hl.local[span_4](start_span)[span_4](end_span)
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

      node.vm.provision "shell", inline: "ip -4 -o a"
    end
  end

end
