function set-git-config-personal() {
  git config user.email "trmaphi@gmail.com"
  git config core.editor "vim"
}

function stop-all-docker-container() {
  docker stop $(docker ps -aq)
}

function rm-all-docker-container() {
  docker rm $(docker ps -aq)
}