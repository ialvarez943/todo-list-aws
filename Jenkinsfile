pipeline {
  agent any

  options {
    skipDefaultCheckout()
  }

  environment {
    ENVIRONMENT = 'staging'
    GIT_BRANCH = 'develop'
    GIT_URL = 'github.com/ialvarez943/todo-list-aws.git'
    STACK_NAME = 'staging-todo-list-aws'
  }

  stages {
    stage('Get Code') {
        steps{
            echo "-------------------- Get Code --------------------"
            git branch: "${env.GIT_BRANCH}", url: "https://${env.GIT_URL}"
            stash name: 'code', includes: '**'
        }
    }

    stage('Setup') {
        steps{
            echo "-------------------- Setup --------------------"
            sh "bash pipelines/PIPELINE-FULL-STAGING/setup.sh"
        }
    }

    stage('Static Test') {
        steps{
            echo "-------------------- Static Test --------------------"
            sh "bash pipelines/PIPELINE-FULL-STAGING/static_test.sh"
            echo "-------------------- Unit Test --------------------"
            sh "bash pipelines/PIPELINE-FULL-STAGING/unit_test.sh"
        }
        post {
            always {
                recordCoverage(tools: [[parser: 'COBERTURA', pattern: 'coverage.xml']])
                recordIssues(tools: [flake8(pattern: 'flake8.out')])
                recordIssues(tools: [pyLint(name: 'Bandit', pattern: 'bandit.out')])
                junit 'result-test.xml'
            }
        }
    }

    stage("Build") {
        steps{
            echo "-------------------- Build --------------------"
            sh "bash pipelines/common-steps/build.sh"
        }
    }

    stage("Deploy") {
        steps{
            echo "-------------------- Deploy --------------------"
            sh "bash pipelines/common-steps/deploy.sh"
        }
    }

    stage("Rest Test") {
        steps{
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

}