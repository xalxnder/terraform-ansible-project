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
                sh 'terraform apply -no-color'
            }
        }

        stage('Destroy'){
            steps {
                sh 'terraform destroy -no-color'
            }
    }
}
}