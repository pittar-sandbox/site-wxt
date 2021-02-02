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
                        ls -l

                        composer.phar clearcache && \
                        composer.phar install \
                            --no-interaction \
                            --no-ansi \
                            --verbose \
                            --optimize-autoloader \
                            --ignore-platform-reqs
                        
                        ls -l vendor
                    """
                    builder.buildApp("${IMAGE_NAME}")
                }
            }
        }
    }
}
