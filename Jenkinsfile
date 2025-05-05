pipeline {
  agent any

  environment {
    // OCI credentials injected via Jenkins credentials
    TF_VAR_tenancy_ocid     = credentials('oci-tenancy-ocid')
    TF_VAR_user_ocid        = credentials('oci-user-ocid')
    TF_VAR_fingerprint      = credentials('oci-fingerprint')
    TF_VAR_region           = credentials('oci-region')
   TF_VAR_private_key_path = '/var/lib/jenkins/.oci/oci_api_key_pkcs8.pem'


  }

  stages {
    stage('Checkout Repository') {
      steps {
        git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/AppsysGlobal/Terraform.git'
      }
    }

   stage('Terraform Init & Apply') {
  steps {
    dir('terraform') {
      sh '''
        echo "TENANCY: $TF_VAR_tenancy_ocid"
        echo "USER: $TF_VAR_user_ocid"
        echo "FINGERPRINT: $TF_VAR_fingerprint"
        echo "REGION: $TF_VAR_region"

        echo "🧪 DEBUGGING PRIVATE KEY"
        echo "Key path = $TF_VAR_private_key_path"
        head -n 2 $TF_VAR_private_key_path

        echo "🔧 Running terraform init"
        terraform init

        echo "🚀 Running terraform apply"
        terraform apply -auto-approve
      '''
    }
  }
}
stage('Run Ansible Playbook') {
  steps {
    echo '📁 Listing files in the workspace:'
    sh 'ls -R'

    echo '📁 Listing contents of ansible folder:'
    sh 'ls -l ansible'

    echo '📄 Showing contents of inventory.ini:'
    sh 'cat ansible/inventory.ini'
    stage('Generate Inventory File') {
      steps {
        writeFile file: 'ansible/inventory.ini', text: """[oci_vm]
141.148.76.76 ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/ocidevopsvmkey"""
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh 'ansible-playbook -i ansible/inventory.ini ansible/apache.yml'
      }
    }
  }

  post {
    success {
      echo "✅ Terraform provisioned and Apache installed via Ansible"
    }
    failure {
      echo "❌ Something went wrong. Check the logs."
    }
  }
}
