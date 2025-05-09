

# Use existing VCN for instance creation
resource "oci_core_instance" "test_instance" {
  lifecycle {
    ignore_changes = [metadata, create_vnic_details]  
  }
  availability_domain = "Rnan:US-ASHBURN-AD-1"
  compartment_id      = var.compartment_ocid
  shape = "VM.Standard.E2.1.Micro"
  display_name        = "Test-Instance"

  create_vnic_details {
    subnet_id = "ocid1.subnet.oc1.iad.aaaaaaaaxeyq7yugxchxhh74vfl6tmfojvyuqpdy567svjpw3xh3ex6d2mwa"
    assign_public_ip = true
    display_name     = "test-vnic"
    hostname_label   = "testvm"
  }

  metadata = {
    ssh_authorized_keys = file(var.ssh_public_key_path)
    terraform_log = "Instance created with Terraform"
  }

  source_details {
    source_type = "image"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaawewgudkwygjwoav2qymlfbbnhhesbqqp5gscroizizolah3bv6kq"
    
  }
}

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

data "oci_core_images" "oracle_linux_image" {
  compartment_id           = var.tenancy_ocid
  operating_system         = "Oracle Linux"
  operating_system_version = "7.9"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

