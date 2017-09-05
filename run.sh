# Create the logs/ directory in case it's not already there
mkdir -p logs/

# Initialize some variables:
#	build_log = Where the docker build log goes
#	run_announcement = Stating what this process is and what time it is run
#	length = The length of the run_announcement + 12 for formatting
#	delimeter = Creates a delimter of #'s that is $length long
build_log=logs/docker_build.txt
run_announcement="Run.sh Build process called on $(date)"
length=$((${#run_announcement} + 12))
delimeter=$(printf "%-${length}s" "#")

# Echo the delimiter, the run announcement, and the delimiter again
echo "${delimeter// /#}" > $build_log
echo "##### $run_announcement #####" >> $build_log
echo "${delimeter// /#}" >> $build_log

# Build the image passed as a parameter, print whether it was successful or not
# and then echo the full build status into the build_log
build_and_echo_status() {
	echo "$1 is being built..."
	image_name="$(echo $1 | tr '[A-Z]' '[a-z]')"
	image=$(docker build -t selenium/$image_name -f Dockerfiles/$1 . &)
	if [[ $image == *"Successfully built"* ]]; then
		echo "$1 image was successfully built!"
		echo "$image" >> $build_log
	else
		echo "Error building $1, please check the log at $build_log"
		echo "$image" >> $build_log
		exit
	fi
	echo ''
}
echo "${delimeter// /#}"
build_and_echo_status Base
build_and_echo_status Hub
build_and_echo_status Node-Base
build_and_echo_status Firefox
build_and_echo_status Chrome
echo "${delimeter// /#}"

# Set the display; this will work for UNIX systems but let's check OS
export DISPLAY=$(ipconfig getifaddr en0):0

# Get the OS and then check to see what the OS is; MING corresponds to Microsoft, else run UNIX syntax
unamestr=`uname`
if [[ "$unamestr" == *'MING'* ]]; then
	export DISPLAY=$((ipconfig | (awk '/IPv4 Address/{print substr($0, 12)}' | cut -d ':' -f 2) | cut -d $'\n' -f 1) | xargs):0
else
	export DISPLAY=$(ipconfig getifaddr en0):0
fi

docker-compose up -d
echo ${docker-compose up -d} >> /dev/null
echo "Selenium hub is up and running. Type 'docker ps' to see all running containers"
