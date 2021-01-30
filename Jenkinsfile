@Library('ised-cicd-lib') _

pipeline {
    agent {
        label 'php-7.3'
    }

    options {
        disableConcurrentBuilds()
    }

    environment {
        // GLobal Vars
        IMAGE_NAME = "drupal-wxt"
    }

    stages {
        stage('build') {
            steps {
                script {
                    sh"""
                        git clone https://scm.ised-isde.canada.ca/scm/is/ised-ocp-scripts.git
                    """
                    builder.buildApp("${IMAGE_NAME}")
                }
            }
        }
    }
}
