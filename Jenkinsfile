#!/usr/bin/env groovy

import groovy.transform.Field

@Field
String SSH_ID_REF = 'ssh-credentials-id'
@Field
String DOCKER_USER_REF = 'dong-dockerhub'

pipeline {
    agent any

    tools {
        dockerTool 'docker'
    }

    stages {
        stage('Build') {
            steps {
                sh 'docker build -t donghq3/devops-todo-app:0.0.2 .'
            }
        }
        stage("Docker login and push docker image") {
            steps {
                withBuildConfiguration {
                    sh 'docker login -u ${repository_username} -p ${repository_password}'
                    sh 'docker push donghq3/devops-todo-app:0.0.2'        		
                }
            }
        }
        stage("deploy") {
             steps {
                 withBuildConfiguration {
                     sshagent(credentials: [SSH_ID_REF]) {
                         sh '''
                            ssh -o StrictHostKeyChecking=no root@ec2-18-143-167-76.ap-southeast-1.compute.amazonaws.com "docker run --detach --name dong-todo-app -p 32145:8000 donghq3/devops-todo-app:0.0.2"
                            docker ps -a
                            '''
                    }
                }
            }
        }
    }
}

void withBuildConfiguration(Closure body) {
    withCredentials([string(credentialsId: 'dong_dockerhub', usernameVariable: 'donghq3', passwordVariable: 'dongpassword')]) {
        body()
    }
}