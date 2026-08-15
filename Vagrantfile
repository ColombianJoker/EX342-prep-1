require 'fileutils'

Vagrant.configure("2") do |config|
  # Using the ARM64 AlmaLinux 8 box for M1 compatibility while matching the RHEL 8 exam environment
  config.vm.box = "bento/almalinux-8-arm64"
  
  # 1. Ansible Control Node
  config.vm.define "ansible-control" do |node|
    node.vm.hostname = "ansible-control.hl.local"
    node.vm.network "private_network", ip: "192.168.56.10"
    node.vm.provider "vmware_desktop" do |vmw|
      vmw.memory = "1024"
      vmw.vmx["numvcpus"] = "2"
    end
  end

  # 2-4. Managed Hosts (ansible2, ansible3, ansible4)
  (2..4).each do |i|
    name = "ansible#{i}"
    config.vm.define name do |node|
      node.vm.hostname = "#{name}.hl.local"
      node.vm.network "private_network", ip: "192.168.56.1#{i}"
      node.vm.provider "vmware_desktop" do |vmw|
        vmw.memory = "512"
        vmw.vmx["numvcpus"] = "1"
      end
    end
  end

  # 5. Managed Host (ansible5) with a 1GB secondary disk
  config.vm.define "ansible5" do |node|
    node.vm.hostname = "ansible5.hl.local"
    node.vm.network "private_network", ip: "192.168.56.15"
    
    # Absolute path to the secondary disk
    disk_path = File.expand_path(".vagrant/machines/ansible5/vmware_desktop/ansible5_disk2.vmdk")

    node.vm.provider "vmware_desktop" do |vmw|
      vmw.memory = "512"
      vmw.vmx["numvcpus"] = "1"
      
      # Attach second drive using SCSI so it enumerates as /dev/sdb
      vmw.vmx["scsi0:1.present"] = "TRUE"
      vmw.vmx["scsi0:1.fileName"] = disk_path
    end

    # Create 1GB disk at the absolute path before booting
    node.trigger.before :up do |trigger|
      trigger.name = "Creating 1GB disk for ansible5"
      trigger.ruby do |env, machine|
        disk_dir = File.dirname(disk_path)

        unless File.exist?(disk_path)
          puts "Creating 1GB virtual disk at #{disk_path}..."
          FileUtils.mkdir_p(disk_dir)
          vdiskmanager = "/Applications/VMware Fusion.app/Contents/Library/vmware-vdiskmanager"
          # -s 1GB creates the 1GB disk required by the sample exam
          system("\"#{vdiskmanager}\" -c -s 1GB -a lsilogic -t 0 \"#{disk_path}\"")
        end
      end
    end
  end
end
