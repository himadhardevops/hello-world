podTemplate(label: "app-builder",
      containers: [
        containerTemplate(
          name: "builder",
          image: "ouyannz/golang-build:dev",
          alwaysPullImage: true,
          ttyEnabled: true,
          command: 'cat',
          resourceRequestCpu: '.6',
          resourceRequestMemory: '1024Mi'
        ),
        containerTemplate(
          name: "deployer",
          image: "alpine/helm:latest",
          alwaysPullImage: true,
          ttyEnabled: true,
          command: 'cat',
          resourceRequestCpu: '.6',
          resourceRequestMemory: '1024Mi'
        )

      ],
      volumes: [
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
      ],
      serviceAccount: "jenkins"
    ) {
      node("app-builder") {
        container("builder") {
              stage("init") {
                sh 'git config --global user.email "jenkins@localhost" && git config --global user.name "JENKINS"'
                }
              stage("checkout") {
                checkout scm
              }
              stage("build docker image"){
                sh 'docker build -t himadhardevops/hello-world:$VERSION .'
              }
              stage("push docker image"){
                sh 'docker push himadhardevops/hello-world:$VERSION'
              }
        }
        container("deployer"){
          stage("deploy"){
            sh 'helm install --upgrade --name hello-world'
          }
        }
      }
    }
