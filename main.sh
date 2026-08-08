#!/usr/bin/env bash
#Variables
source ./config.sh
source ./logging.sh

log_info "----SCRIPT STARTED----"
log_info "Use SSH key is set to $USE_KEY"

################################################################################## Create archive locally


log_info "Creating archive..."
ARCHIVE_NAME="$PREFIX-archive-$DATE.zip"

if zip -r  -v "./$ARCHIVE_NAME" "${DIRS[@]}" ; then
     log_success "Successfully created archive"
    else
        log_error "Issues were encountered while creating archive"
fi

################################################################################## Export Archive
log_info "Copying archive to remote repo..."
if [ $USE_KEY = true ]; then
    log_info "Using ssh key $SSH_KEY"

     if [ -f $SSH_KEY ]; then   #check if file exists

        if scp -i $SSH_KEY "$ARCHIVE_NAME" "$REMOTE_REPO" ; then
            log_success "Done"
        else
            log_error "Issues were encountered while copying archive to remote repo"
        fi
    else
        log_error "Could not find key file $SSH_KEY"  #error out if file does not exist

    fi
else
    log_info "Using SSH password"
    if sshpass -p $PASSWORD scp "$ARCHIVE_NAME" "$REMOTE_REPO" ; then
        log_success "Done"
    else
        log_error "Issues were encountered while copying archive to remote repo"
    fi
fi

################################################################################## Delete local Archive
log_info "Deleting local archive file..."
if rm -f $ARCHIVE_NAME ; then
    log_success "Done"
else
    log_error "Issues were encountered while deleting local archive $ARCHIVE_NAME"
fi

log_info "----SCRIPT FINISHED----"