pipeline {
    agent any

    tools {
        jdk 'jdk11'
        maven 'maven3'
    }

    environment {
        SCANNER_HOME = tool 'sonar-scanner'
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/adityaglobe/Petclinicnew.git'
            }
        }

        stage('Compile') {
            steps {
                sh 'mvn clean compile'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }
        }

        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sonar-server') {
                    sh '''
                    $SCANNER_HOME/bin/sonar-scanner \
                    -Dsonar.projectKey=petclinic \
                    -Dsonar.projectName=petclinic \
                    -Dsonar.java.binaries=target
                    '''
                }
            }
        }

        stage('OWASP Dependency Check') {
            steps {
                dependencyCheck additionalArguments: '--scan .', odcInstallation: 'DP'
                dependencyCheckPublisher pattern: '**/dependency-check-report.xml'
            }
        }

        stage('Build WAR') {
            steps {
                sh 'mvn clean install'
            }
        }

        stage('Docker Build & Push') {
            steps {
                withDockerRegistry(credentialsId: 'dockerhub-creds') {
                    sh '''
                    docker build -t adijaiswal/pet-clinic123:latest .
                    docker push adijaiswal/pet-clinic123:latest
                    '''
                }
            }
        }

        stage('Trivy Scan') {
            steps {
                sh 'trivy image adijaiswal/pet-clinic123:latest'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                sh '''
                cp target/*.war /opt/apache-tomcat-9.0.65/webapps/
                '''
            }
        }
    }
}
