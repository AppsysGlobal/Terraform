pipeline {
  agent any

  environment {
    TF_VAR_tenancy_ocid     = credentials('oci-tenancy-ocid')
    TF_VAR_user_ocid        = credentials('oci-user-ocid')
    TF_VAR_fingerprint      = credentials('oci-fingerprint')
    TF_VAR_region           = credentials('oci-region')
    TF_VAR_private_key_path = '/var/lib/jenkins/.oci/oci_api_key_pkcs8.pem'
  }

  stages {
    stage('Checkout') {
      steps {
        git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/AppsysGlobal/Terraform.git'
      }
    }

    stage('Terraform Init') {
      steps {
        dir('terraform') {
          sh 'terraform init'
        }
      }
    }

    stage('Terraform Import Existing Resources') {
      steps {
        dir('terraform') {
          sh '''
            terraform import oci_core_instance.Optimus ocid1.instance.oc1.iad.anuwcljtggm52bqclaqjgzrxtgbganiiijfpdhjqbhowywj4vpyjcfv6bvxa
            terraform import oci_core_virtual_network.existing_vcn ocid1.vcn.oc1.iad.amaaaaaaggm52bqau6nh5vdtsobv57ucuqpqo4wnsyy5tv6w3aotybggerca
            terraform import oci_objectstorage_bucket.existing_bucket idyhabl91i8j/Doc-understanding-storage
          '''
        }
      }
    }

    stage('Terraform Plan') {
      steps {
        dir('terraform') {
          sh 'terraform plan'
        }
      }
    }
  }

  post {
    success {
      echo '✅ Imported existing resources successfully!'
    }
    failure {
      echo '❌ Failed to import or plan. Check logs.'
    }
  }
}
