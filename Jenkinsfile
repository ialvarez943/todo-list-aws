pipeline {
  agent any

  options {
    skipDefaultCheckout()
  }

  environment {
    ENVIRONMENT = 'staging'
    GIT_BRANCH = 'develop'
    GIT_URL = 'github.com/ialvarez943/todo-list-aws.git'
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
            sh "bash pipelines/PIPELINE-FULL-STAGING/unit_test.sh"
        }
        post {
            always {
                recordIssues tools: [flake8(pattern: 'flake8.out')]
                recordIssues tools: [pyLint(name: 'Bandit', pattern: 'bandit.out')]
                junit 'result-test.xml'
            }
        }
    }
  }

}