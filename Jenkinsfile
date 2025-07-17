pipeline {
  agent any

  environment {
    ANSIBLE_HOST_KEY_CHECKING = 'False'
  }

  stages {
    stage('Checkout Repo') {
      steps {
        git branch: 'main', url: 'https://github.com/KamzyPrinzel/New-Year-Countdown-Timer.git'
      }
    }

    stage('Run Ansible Playbook') {
      steps {
        dir('Ansible') {
          withCredentials([sshUserPrivateKey(credentialsId: 'ansible-ssh-key', keyFileVariable: 'SSH_KEY')]) {
            sh '''
              ansible-playbook -i inventory.yaml playbook.yaml \
              --private-key=$SSH_KEY
            '''
          }
        }
      }
    }
  }
}



