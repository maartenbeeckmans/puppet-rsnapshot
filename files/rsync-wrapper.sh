#!/bin/bash
### File managed with Puppet
echo Started "$@" from "$SSH_CLIENT"| logger -t rsync-wrapper
sudo /usr/bin/rsync "$@"

