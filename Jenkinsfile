#! /usr/bin/env groovy

pipeline {
    agent any 

    stages {
        stage("provision eks cluster") {
            environment {
                AWS_ACCESS_KEY_ID = credentials('jenkins_aws_access_key_id')
                AWS_SECRET_ACCESS_KEY = credentials('jenkins_aws_secret_access_key')
            }
            steps {
                script {
                    echo 'provising eks cluster...'
                    sh 'terraform init'
                    sh 'terraform apply -var-file envs/dev/dev.tfvars --auto-approve'
                }
            }
        }

    }
}