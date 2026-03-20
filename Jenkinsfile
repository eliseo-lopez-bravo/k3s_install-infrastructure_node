pipeline {
    agent any

    stages {
        stage('Checkout Code') {
            steps {
                git url: 'https://github.com/eliseo-lopez-bravo/k3s_install-infrastructure_node.git', branch: 'main'
            }
        }

        stage('Run Shell Script') {
            steps {
                sh 'chmod +x ./create_image/hello.sh'
                sh './create_image/hello.sh'
            }
        }
    }
}