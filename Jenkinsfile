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
                ansiblePlaybook(installation: '/Library/Frameworks/Python.framework/Versions/3.11/bin', credentialsId: 'ec2-ssh-key', inventory: 'aws_hosts', playbook: 'playbooks/main_playbook.yml')
            }
        }
        stage('Destroy'){
            steps {
                sh 'terraform destroy -auto-approve -no-color'
            }
    }
}
}