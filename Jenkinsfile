pipeline {
    agent any

    options {
        skipDefaultCheckout()
    }

    environment {
        ENVIRONMENT = 'production'
        GIT_BRANCH = 'master'
        GIT_URL = 'github.com/ialvarez943/todo-list-aws.git'
        STACK_NAME = 'production-todo-list-aws'
        PIPELINE_FOLDER = 'PIPELINE-FULL-PRODUCTION'
    }

    stages {

        stage('Get Code') {
            steps {
                echo "-------------------- Get Code --------------------"
                git branch: "${env.GIT_BRANCH}", url: "https://${env.GIT_URL}"
                stash name: 'code', includes: '**'
            }
        }

        stage('Setup') {
            steps {
                echo "-------------------- Setup --------------------"
                sh "bash pipelines/${env.PIPELINE_FOLDER}/setup.sh"
            }
        }

        stage("Build") {
            steps {
                echo "-------------------- Build --------------------"
                sh "bash pipelines/common-steps/build.sh"
            }
        }

        stage("Deploy") {
            steps {
                echo "-------------------- Deploy --------------------"
                sh "bash pipelines/common-steps/deploy.sh"
            }
        }

        stage("Rest Test") {
            steps {
                echo "-------------------- Rest Test --------------------"
                script {
                    def BASE_URL = sh( script: "aws cloudformation describe-stacks --stack-name ${env.STACK_NAME} --query 'Stacks[0].Outputs[?OutputKey==`BaseUrlApi`].OutputValue' --region us-east-1 --output text",
                        returnStdout: true)
                    echo "$BASE_URL"
                    sh "bash pipelines/common-steps/integration.sh $BASE_URL"
                }
            }
            post {
                    always {
                        junit 'result-integration.xml'
                    }
            }
        }
    }

    post { 
        always { 
            echo 'Clean env: delete dir'
            cleanWs()
        }
    }
}