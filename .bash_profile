### Bash-it configuration
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

export BASH_IT="${HOME}/.bash_it"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='minimal'

# Don't check mail when opening terminal.
unset MAILCHECK

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Load Bash-it
source "$BASH_IT"/bash_it.sh

### OS specific code
# Linux
if [[ "$OSTYPE" == "linux-gnu" ]]; then
	# Set JAVA_HOME
	export JAVA_HOME=/usr/lib/jvm/java-1.8.0-amazon-corretto
fi

# Darwin 
if [[ "$OSTYPE" == "darwin"* ]]; then
	# Add Visual Studio Code (code)
	export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" 
	
	# Load linux vm in Docker toolbox
	load_docker_engine(){
	. '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
	}
fi

# Set GO_PATH environment variable
export GOPATH=$(go env GOPATH)
