def call(String dockerImageName, String dockerfileSource) {
    stage("${dockerImageName}'s image") {
        dir(dockerfileSource) {
            echo "- Building the docker image: ${dockerImageName}..."
            sh "docker build -t ${dockerImageName} ."
            echo "- The docker image: ${dockerImageName} was built successfully"
        }
    }
}