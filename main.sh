#!/usr/bin/env bash
#Variables
source ./config.sh
source ./logging.sh

write_log "----SCRIPT STARTED----"
write_log "Use SSH key is set to $USE_KEY"

################################################################################## Create archive locally


write_log "Creating archive..."
ARCHIVE_NAME="$PREFIX-archive-$DATE.zip"

if zip -r  -v "./$ARCHIVE_NAME" "${DIRS[@]}" ; then
     write_log "Successfully created archive"
    else
        write_error "Issues were encountered while creating archive"
fi

################################################################################## Export Archive
write_log "Copying archive to remote repo..."
if [ $USE_KEY = true ]; then
    write_log "Using ssh key $SSH_KEY"

     if [ -f $SSH_KEY ]; then   #check if file exists

        if scp -i $SSH_KEY "$ARCHIVE_NAME" "$REMOTE_REPO" ; then
            write_log "Done"
        else
            write_error "Issues were encountered while copying archive to remote repo"
        fi
    else
        write_error "Could not find key file $SSH_KEY"  #error out if file does not exist

    fi
else
    write_log "Using SSH password"
    if sshpass -p $PASSWORD scp "$ARCHIVE_NAME" "$REMOTE_REPO" ; then
        write_log "Done"
    else
        write_error "Issues were encountered while copying archive to remote repo"
    fi
fi

################################################################################## Delete local Archive
write_log "Deleting local archive file..."
if rm -f $ARCHIVE_NAME ; then
    write_log "Done"
else
    write_error "Issues were encountered while deleting local archive $ARCHIVE_NAME"
fi

write_log "----SCRIPT FINISHED----"