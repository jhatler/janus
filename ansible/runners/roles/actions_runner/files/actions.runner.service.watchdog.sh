#!/bin/bash

function _stop_trap() {
    # convert SIGTERM signal to SIGINT
    # for more info on how to propagate SIGTERM to a child process
    # see: http://veithen.github.io/2014/11/16/sigterm-propagation.html
    kill -INT "$(cat .runner-pid)"
}

function _reload_trap() {
    # stop the current runner
    _stop_trap

    # wait for it to exit
    wait "$(cat .runner-pid)"
    trap - TERM INT
    wait "$(cat .runner-pid)"

    # relaunch this script
    exec $0
}

trap _stop_trap TERM INT
trap _reload_trap USR1

source /etc/profile

nodever=${GITHUB_ACTIONS_RUNNER_FORCED_NODE_VERSION:-node16}

# insert anything to setup env when running as a service here

# run the host process which keep the listener alive
"./externals/${nodever}/bin/node" ./bin/RunnerService.js &
echo $! >.runner-pid

while ((1)); do
    sleep 3

    # check if the runner is still running
    if ! kill -0 "$(cat .runner-pid)" >&/dev/null; then
        break
    fi

    # Clean docker if the disk space is less than 10%
    if [ "$(df "$(pwd)" | awk 'END{print $5}' | tr -d '%')" -gt 90 ]; then
        docker images -aq | xargs docker rmi -f
        docker buildx prune -a -f
    fi

    # Stop the runner if it has been inactive for more than the cooloff period
    if [ "$(find .runner-inactive -mmin "+$(cat .runner-cooloff)" | wc -l)" -gt 0 ]; then
        echo "Runner is inactive for more than $(cat .runner-cooloff) mins, stopping the runner"
        sudo systemctl poweroff
        break
    fi
done

wait "$(cat .runner-pid)"
trap - TERM INT
wait "$(cat .runner-pid)"

rm -f .runner-pid
