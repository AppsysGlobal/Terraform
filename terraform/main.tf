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
resource "oci_objectstorage_bucket" "existing_bucket" {
  name           = "Doc-understanding-storage"
  compartment_id = var.compartment_ocid
  namespace      = "idyhabl91i8j"
}



output "bucket_name" {
  value = oci_objectstorage_bucket.existing_bucket.name
}
