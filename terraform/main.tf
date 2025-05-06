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

# Existing VM import placeholder
resource "oci_core_instance" "Optimus" {
  # No fields required; used for importing existing instance
}

# Existing VCN import placeholder
resource "oci_core_virtual_network" "existing_vcn" {
  # No fields required; used for importing existing VCN
}

# Existing Bucket import placeholder
resource "oci_objectstorage_bucket" "existing_bucket" {
  # No fields required; used for importing existing bucket
}

# Outputs to confirm import
output "vm_ocid" {
  value = oci_core_instance.optimus.id
}

output "vcn_ocid" {
  value = oci_core_virtual_network.existing_vcn.id
}

output "bucket_name" {
  value = oci_objectstorage_bucket.existing_bucket.name
}
