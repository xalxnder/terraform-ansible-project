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
    }
}