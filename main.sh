#!/usr/bin/env bash
#Variables
source ./config.sh
source ./logging.sh

# === Exit Codes === #
readonly EXIT_SUCCESS=0
readonly EXIT_DIR_DOESNT_EXIST=1
readonly EXIT_INVALID_ARGS=2
readonly EXIT_MISSING_DEP=3
readonly EXIT_CANNOT_ZIP=21
readonly EXIT_CANNOT_COPY=22
readonly EXIT_NO_SSH_KEY=23
readonly EXIT_CANNOT_DELETE=24

# === PRE FLIGHT CHECKS ===#
# check if required binaries exist
[ -x "/usr/bin/zip" ] || { log_error "Required binary missing: /usr/bin/zip"; exit EXIT_MISSING_DEP; }

# set variables
log_info "----SCRIPT STARTED----"
log_info "Use SSH key is set to $USE_KEY"
DATE=$(date '+%Y-%m-%d %H:%M:%S')
ARCHIVE_NAME="$PREFIX-archive-${DATE}.zip"

# check if source exists
for dir in "${DIRS[@]}"; do
    [ -d "$dir" ] || { log_error "Directory $dir does not exist"; exit 1; }
done

# === TRAPS === #
function cleanup()
{
    rm -rf "tmp/$ARCHIVE_NAME"
    log_warn "Process interrupted, cleaning up and exiting"
}

trap cleanup INT TERM
################################################################################## Create archive locally
log_info "Creating archive..."


if zip -r  -v "/tmp/$ARCHIVE_NAME" "${DIRS[@]}" ; then
     log_success "Successfully created archive /tmp/$ARCHIVE_NAME"
     chmod 660 "/tmp/$ARCHIVE_NAME"
    else
        log_error "Issues were encountered while creating archive"
        exit $EXIT_CANNOT_ZIP
fi

################################################################################## Export Archive
log_info "Copying archive to remote repo..."
if [ $USE_KEY = true ]; then
    log_info "Using ssh key $SSH_KEY"

     if [ -f $SSH_KEY ]; then   #check if file exists

        if scp -i $SSH_KEY "/tmp/$ARCHIVE_NAME" "$REMOTE_REPO" ; then
            log_success "Done"
        else
            log_error "Issues were encountered while copying archive to remote repo"
        fi
    else
        log_error "Could not find key file $SSH_KEY"  #error out if file does not exist

    fi
fi

################################################################################## No matter what, always delete local Archive
log_info "Deleting local archive file /tmp/$ARCHIVE_NAME"
if rm -f "/tmp/$ARCHIVE_NAME" ; then
    log_success "Done"
else
    log_error "Issues were encountered while deleting local archive /tmp/$ARCHIVE_NAME"
    exit $EXIT_CANNOT_DELETE
fi

log_info "----SCRIPT FINISHED----"