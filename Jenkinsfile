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
    stage('Checkout Repository') {
      steps {
        git branch: 'main', credentialsId: 'github-creds', url: 'https://github.com/AppsysGlobal/Terraform.git'
      }
    }

    stage('Terraform Init & Apply') {
      steps {
        dir('terraform') {
          sh '''
            echo "🔧 Running terraform init"
            terraform init

            echo "🚀 Running terraform apply"
            terraform apply -auto-approve
          '''
        }
      }
    }

    stage('Extract Public IP & Generate Inventory') {
      steps {
        dir('terraform') {
          script {
            def publicIp = sh(script: "terraform output -raw vm_public_ip", returnStdout: true).trim()
            echo "✅ Extracted Public IP: ${publicIp}"

            // Write inventory.ini dynamically
            writeFile file: 'ansible/inventory.ini', text: """[oci_vm]
${publicIp} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/ocidevopsvmkey
"""
          }
        }
      }
    }

    stage('Debug Inventory') {
      steps {
        sh 'cat ansible/inventory.ini'
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        sh 'ansible-playbook -i Ansible/inventory.ini Ansible/apache.yml'
      }
    }
  }

  post {
    success {
      echo "✅ Terraform provisioned VM and Ansible installed Apache successfully"
    }
    failure {
      echo "❌ Something went wrong. Check the logs."
    }
  }
}
