build_and_echo_status() {
  image_name="$(echo $1 | tr '[A-Z]' '[a-z]')"
  image=$(docker build -t selenium/$image_name -f Dockerfiles/$1 .  | tail -n1)
  if [[ $image == *"Successfully built"* ]]; then
    echo "$1 image was successfully built!"
    echo "$image" >> $build_log
  else
    echo "Error building $1, please check the log at $build_log"
    echo "$image" >> $build_log
    exit
  fi
}
build_and_echo_status Base
build_and_echo_status Hub
build_and_echo_status Node-Base
build_and_echo_status Firefox
build_and_echo_status Firefox-Headless
build_and_echo_status Chrome
build_and_echo_status Chrome-Headless
