# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" 

# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
if [[ "$OSTYPE" == "linux-gnu" ]]; then
  export BASH_IT="/home/truong/.bash_it"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  export BASH_IT="/Users/truong/.bash_it"
fi

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash It
source "$BASH_IT"/bash_it.sh

# Set JAVA_HOME
export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto

load_docker_engine(){
. '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
}
