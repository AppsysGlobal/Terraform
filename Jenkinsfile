pipeline {
    agent any

    environment {
        TF_VAR_private_key_path = "/home/ubuntu/.oci/oci_api_key_pkcs8.pem"
        TF_VAR_ssh_public_key_path = "/home/ubuntu/.ssh/id_rsa.pub"
    }

    stages {
        stage('Checkout') {
            steps {
                script {
                    git url: 'https://github.com/AppsysGlobal/Terraform.git', branch: 'main'
                }
            }
        }

        stage('Terraform Init') {
            steps {
                sh '''
                terraform init
                '''
            }
        }

        stage('Terraform Plan') {
            steps {
                sh '''
                terraform plan
                '''
            }
        }

        stage('Terraform Apply') {
            steps {
                sh '''
                terraform apply -auto-approve
                '''
            }
        }
    }

    post {
        always {
            echo 'Cleaning up workspace...'
            cleanWs()
        }
    }
}
