terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 6.0.0"
    }
  }
}

provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = var.region
}

# ✅ DEBUG: Output injected authentication values
output "debug_auth_variables" {
  value = {
    tenancy_ocid     = var.tenancy_ocid
    user_ocid        = var.user_ocid
    fingerprint      = var.fingerprint
    region           = var.region
    private_key_path = var.private_key_path
  }
  sensitive = true
}

# ✅ Get AD list
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# ✅ Get Ubuntu image for specified shape
data "oci_core_images" "ubuntu_image" {
  compartment_id           = var.compartment_ocid
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "22.04"
  shape                    = "VM.Standard.E2.1.Micro"
}

# ✅ Launch a VM
resource "oci_core_instance" "vm_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  shape               = "VM.Standard.E2.1.Micro"
  display_name        = "jenkins-test-instance"

  create_vnic_details {
    subnet_id        = var.subnet_id
    assign_public_ip = true
    display_name     = "jenkins-vnic"
    hostname_label   = "jenkinsvm"
  }

  metadata = {
    ssh_authorized_keys = file("id_rsa.pub")
  }

  source_details {
    source_type = "image"
    source_id   = data.oci_core_images.ubuntu_image.images[0].id
  }
}
