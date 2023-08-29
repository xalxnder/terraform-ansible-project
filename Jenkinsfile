pipeline {
    agent any
    stages {
        stage('Init'){
            steps {
                sh 'ls'
                sh 'terraform init -no-color'
            }
        }
        stage('Plan') {
            steps {
                sh 'terraform plan -no-color'

            }
        } 

        stage('Apply') {
            steps {
                sh 'terraform apply -auto-approve -no-color'
            }
        }
        stage('Ansible'){
            steps {
                sh 'ansible-playbook -i aws_hosts --key-file /Users/xalexander/.ssh/architech_key playbooks/main_playbook.yml'
            }
        }

         stage('Testing'){
            steps {
                sh 'ansible-playbook -i aws_hosts --key-file /Users/xalexander/.ssh/architech_key playbooks/service_tests.yml'
            }
        }

  }
  post {
    success {
        echo "Success!!!"
    }

    failure {
        sh 'terraform destroy -auto-approve -no-color'
    }
  }
}