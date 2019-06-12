# Darwin 
if [[ "$OSTYPE" == "darwin"* ]]; then
	# Add Visual Studio Code (code)
	export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin" 
	
	# Load linux vm in Docker toolbox
	load-docker-toolbox(){
	. '/Applications/Docker/Docker Quickstart Terminal.app/Contents/Resources/Scripts/start.sh'
	}
fi