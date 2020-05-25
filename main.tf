provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}" 
# Yes I know this isn't a good practice. TODO: Set up a better way of holding these credentials later."
  vsphere_server = "${var.vsphere_server}"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#Generate random string for hostname
resource "random_string" "random" {
  length = 6
  special = false

}

data "vsphere_datacenter" "dc" {
	name = "Datacenter"
}

data "vsphere_datastore" "datastore_1" {
	name = "${var.datastore}"
	datacenter_id = data.vsphere_datacenter.dc.id
}
# Note: for standalone hosts, reference host in place of cluster. https://github.com/terraform-providers/terraform-provider-vsphere/issues/262
# https://github.com/terraform-providers/terraform-provider-vsphere/issues/553
data "vsphere_host" "host" {
	name = "${var.host}"
	datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "vm_network" {
	name = "VM Network"
  	datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "windows_template" {
	name = "Win2016_Template"
	datacenter_id = data.vsphere_datacenter.dc.id
}

#Create the actual vm below.


resource "vsphere_virtual_machine" "csps" {
	name = "choutlaw_csps_${random_string.random.result}"
	resource_pool_id = data.vsphere_host.host.resource_pool_id
	host_system_id = data.vsphere_host.host.id
	datastore_id = data.vsphere_datastore.datastore_1.id
	guest_id = data.vsphere_virtual_machine.windows_template.guest_id
	num_cpus = 2
	memory = 4096
	network_interface {
		network_id = data.vsphere_network.vm_network.id
	}
	disk {
		label = "os_disk_1"
		size = 50
		thin_provisioned = true
	}
	clone {
		template_uuid = data.vsphere_virtual_machine.windows_template.id
	}
}
