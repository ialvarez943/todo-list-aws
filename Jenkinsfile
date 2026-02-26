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
            git branch: "${env.GIT_BRANCH}", url: "https://${env.GIT_URL}"
            stash name: 'code', includes: '**'
        }
    }
  }

}