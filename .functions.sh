function stop-all-docker-container() {
  docker stop $(docker ps -aq)
}

function rm-all-docker-container() {
  docker rm $(docker ps -aq)
}