#!/bin/sh

runServer() {
  echo "starting smocker"
  (cd /opt && /opt/smocker &)
  printf "loading smocker mocks"
  wait 1
  counter=0
  until curl --output /dev/null --silent --fail http://localhost:8081/version; do
      counter=$((counter+1))
      if [ "$counter" = 20 ]; then
          printf "\n" # new line
          echo "Unable to connect to Smocker"
          exit 1
      fi
      printf  '%s' '.'
      sleep 0.5
  done
  printf "\n" # new line

  find "/mocks" -name "*.yml" -type f -exec \
      curl -XPOST \
      --header "Content-Type: application/x-yaml" \
      --data-binary "@{}" \
      --silent \
      http://localhost:8081/mocks \;

  echo "smocker started"
}

killRunningServer() {
  pkill smocker || true
}

rerunServer () {
  killRunningServer
  runServer
}

lockBuild() {
  # check lock file existence
  if [ -f /tmp/server.lock ]; then
    # waiting for the file to delete
    inotifywait -e DELETE /tmp/server.lock
  fi
  touch /tmp/server.lock
}

unlockBuild() {
  # remove lock file
  rm -f /tmp/server.lock
}

# run the server for the first time
runServer

echo "waiting for file changes"
inotifywait -e MODIFY -r -m /mocks --include "\.yml" . |
  while read -r path action file; do
    lockBuild
    rerunServer
    unlockBuild
  done
