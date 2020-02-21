function set-git-config-personal() {
  git config user.email "trmaphi@gmail.com"
  git config core.editor "vim"
}

get-git-current-remote-branch() {
  git rev-parse --abbrev-ref --symbolic-full-name @{u}
}

stop-all-docker-container() {
  docker stop $(docker ps -aq)
}

rm-all-docker-container() {
  docker rm $(docker ps -aq)
}