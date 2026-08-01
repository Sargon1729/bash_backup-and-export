# docker-backup
Painless way to backup docker containers on remote hosts

Simply copy and rename the `config.example.sh` to `config.sh` and provide the required variables.

Do the same for `compose-files.txt`, place the full path for the compose files, one on each line, and comment out the ones you want to start back up after the backup is complete.

This would work better with an ssh key but for the life of me that private key does not work when the client is the pi, works from everything else so really don't care anymore