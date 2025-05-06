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
data "oci_objectstorage_namespace" "ns" {
  compartment_id = var.compartment_ocid
} 

# Existing Bucket import placeholder
resource "oci_objectstorage_bucket" "existing_bucket" {
  name           = "Doc-understanding-storage"
  compartment_id = var.compartment_ocid
  namespace      = data.oci_objectstorage_namespace.ns.namespace
  # No fields required; used for importing existing bucket
}

output "bucket_name" {
  value = oci_objectstorage_bucket.existing_bucket.name
}
