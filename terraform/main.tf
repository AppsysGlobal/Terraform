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

resource "oci_objectstorage_bucket" "existing_bucket" {
  compartment_id = var.compartment_ocid
  name           = "Doc-understanding-storage"
  namespace      = data.oci_objectstorage_namespace.ns.namespace
}



output "bucket_name" {
  value = oci_objectstorage_bucket.existing_bucket.name
}
