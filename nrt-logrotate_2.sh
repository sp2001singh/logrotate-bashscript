#!/bin/bash
#
# Filename: nrt-logrotate.sh
#
# Author: DevOpsTeam
# Created: 2024-06-04
# Description: This logrotate configuration file is for rotating the log file
#              application-dev.yaml located at /aml/webapp/elastic-service/. (For all environments)
#              The rotated logs are stored in /home/ubuntu/devops/logs/elastic/search.
# Usage: Use this configuration with the logrotate command to manually rotate logs.
#        Example: sudo logrotate -f /path/to/yaml_logrotate.conf (main command to rotate logs)
# Notes:
#   - Ensure the parent directory of the log file has secure permissions. (root with 644)
#   - This configuration uses the copytruncate method to avoid application restart.
# Version: 1.1

# set -eox


# DEV Variables opensearch
#REMOTE_USER="ubuntu"


# # DEV Variable backend
# REMOTE_PATH_DEV_BACKEND="/aml/webapp/" #TODO # change the exat after testing













#     if [ "$service_name" == "backend" ]; then
#         echo "Service name: backend"
#         # Rotate logs on the remote server
#         echo "Starting log rotation on the $ENV server..."
#         ssh -T $REMOTE_HOST <<EOF
#         sudo logrotate -f $LOGROTATE_CONF
# EOF
#         if [ $? -ne 0 ]; then
#         log_error "Log rotation failed on the $ENV server."
#         echo "Log rotation failed on the $ENV server. Check logfile for details."
#         exit 1
#         else
#         echo "Log rotation completed successfully on the $ENV server."
#         fi

#         # Copy the application-dev.yaml file to the remote server
#         echo "Copying $LOCAL_FILE to the $ENV server..."
#         cd ~/ && scp $LOCAL_FILE $REMOTE_FILE

#         if [ $? -ne 0 ]; then
#         log_error "Failed to copy $LOCAL_FILE to the $ENV server."
#         echo "Failed to copy $LOCAL_FILE to the $ENV server. Check logfile for details."
#         exit 1
#         else
#         echo "File copied successfully to the $ENV server."
#         fi

#         # Move the file to the desired directory on the remote server
#         echo "Moving the file to $REMOTE_PATH_OPENSEARCH on the $ENV server..."
#         ssh -T $REMOTE_HOST <<EOF
#         sudo mv ~/application-dev.yaml $REMOTE_PATH_OPENSEARCH
# EOF

#         if [ $? -ne 0 ]; then
#         log_error "Failed to move the file to $REMOTE_PATH_OPENSEARCH on the $ENV server."
#         echo "Failed to move the file to $REMOTE_PATH_OPENSEARCH on the $ENV server. Check logfile for details."
#         exit 1
#         else
#         echo "File moved successfully to $REMOTE_PATH_OPENSEARCH on the $ENV server."
#         fi

#         # Exit the script
#         echo "Script execution completed."
#         exit 0

#     elif [ "$service_name" == "opensearch" ]; then
#         echo "Service name: opensearch"
#     fi



# # UAT Variables
# #REMOTE_USER="ubuntu"
# REMOTE_HOST="nrt-uat"
# LOGROTATE_CONF="/home/ubuntu/devops/yaml_logrotate.conf"
# REMOTE_PATH="/aml/webapp/" # change the exat after testing
# LOCAL_FILE="application-uat.yaml"
# REMOTE_FILE="$REMOTE_HOST:~/"


# # Rotate logs on the remote server
# echo "Starting log rotation on the remote server..."
# ssh -T $REMOTE_HOST <<EOF
#   sudo logrotate -f $LOGROTATE_CONF
# EOF

# if [ $? -ne 0 ]; then
#   log_error "Log rotation failed on the remote server."
#   echo "Log rotation failed on the remote server. Check logfile for details."
#   exit 1
# else
#   echo "Log rotation completed successfully on the remote server."
# fi

# # Copy the application-dev.yaml file to the remote server
# echo "Copying $LOCAL_FILE to the remote server..."
# cd ~/ && scp $LOCAL_FILE $REMOTE_HOST:$REMOTE_FILE

# if [ $? -ne 0 ]; then
#   log_error "Failed to copy $LOCAL_FILE to the remote server."
#   echo "Failed to copy $LOCAL_FILE to the remote server. Check logfile for details."
#   exit 1
# else
#   echo "File copied successfully to the remote server."
# fi

# # Move the file to the desired directory on the remote server
# echo "Moving the file to $REMOTE_PATH on the remote server..."
# ssh -T $REMOTE_HOST <<EOF
#   sudo mv ~/application-dev.yaml $REMOTE_PATH
# EOF

# if [ $? -ne 0 ]; then
#   log_error "Failed to move the file to $REMOTE_PATH on the remote server."
#   echo "Failed to move the file to $REMOTE_PATH on the remote server. Check logfile for details."
#   exit 1
# else
#   echo "File moved successfully to $REMOTE_PATH on the remote server."
# fi

# # Exit the script
# echo "Script execution completed."
# exit 0





####################################################################

# Function to log errors with date and time
log_error() {
  echo "$(date +'%Y-%m-%d %H:%M:%S') - $1" >> error.log
}

# Prompt the user for input and validate
read -p "Enter the Nrt-environment (dev/qa/uat): " ENV

# Validate the input for environment name
case $ENV in
    dev|qa|uat)
    ;;
    *)
        echo "Invalid environment. Please enter environment in small case dev, qa, or uat."
        exit 1
        ;;
esac

read -p "Enter the service name (backend, opensearch): " service_name
# Validate the input for service name
case $service_name in
    "backend")
        backend_func;;
    "opensearch")
        opensearch_func;;
    *)
        echo "Invalid service name. Please enter service name in small case backend, opensearch."
        exit 1
        ;;
esac


# Varibales
REMOTE_HOST="nrt-$ENV"
LOGROTATE_CONF="/home/ubuntu/devops/yaml_logrotate.conf"
REMOTE_PATH_OPENSEARCH="~/devops/opensearch_test/" #TODO   # change the exat after testing
REMOTE_PATH_BACKEND="~/devops/backend_test/" #TODO   # change the exat after testing
LOCAL_FILE="application-dev.yaml"
REMOTE_FILE="~/"

################### opensearch function

opensearch_func() {
  echo "Starting log rotation on the remote server..."
  ssh -T nrt-$ENV <<EOF
    sudo logrotate -f "$LOGROTATE_CONF"
EOF

  if [ $? -ne 0 ]; then
    log_error "Log rotation failed on the remote server."
    echo "Log rotation failed on the remote server. Check logfile for details."
    exit 1
  else
    echo "Log rotation completed successfully on the remote server."
  fi

  # Copy the application-dev.yaml file to the remote server
echo "Copying $LOCAL_FILE to the remote server..."
cd ~/ && scp $LOCAL_FILE $REMOTE_FILE

if [ $? -ne 0 ]; then
  log_error "Failed to copy $LOCAL_FILE to the remote server."
  echo "Failed to copy $LOCAL_FILE to the remote server. Check logfile for details."
  exit 1
else
  echo "File copied successfully to the remote server."
fi

# Move the file to the desired directory on the remote server
echo "Moving the file to $REMOTE_PATH_OPENSEARCH on the remote server..."
ssh -T nrt-$ENV <<EOF
  sudo mv ~/application-dev.yaml $REMOTE_PATH_OPENSEARCH
EOF

if [ $? -ne 0 ]; then
  log_error "Failed to move the file to $REMOTE_PATH_OPENSEARCH on the remote server."
  echo "Failed to move the file to $REMOTE_PATH_OPENSEARCH on the remote server. Check logfile for details."
  exit 1
else
  echo "File moved successfully to $REMOTE_PATH_OPENSEARCH on the remote server."
fi

# Exit the script
echo "Script execution completed."
exit 0

}


########## Backend function

backend_func() {
  echo "Starting log rotation on the remote server..."
  ssh -T nrt-$ENV <<EOF
    sudo logrotate -f "$LOGROTATE_CONF"
EOF

  if [ $? -ne 0 ]; then
    log_error "Log rotation failed on the remote server."
    echo "Log rotation failed on the remote server. Check logfile for details."
    exit 1
  else
    echo "Log rotation completed successfully on the remote server."
  fi

  # Copy the application-dev.yaml file to the remote server
echo "Copying $LOCAL_FILE to the remote server..."
cd ~/ && scp $LOCAL_FILE $REMOTE_FILE

if [ $? -ne 0 ]; then
  log_error "Failed to copy $LOCAL_FILE to the remote server."
  echo "Failed to copy $LOCAL_FILE to the remote server. Check logfile for details."
  exit 1
else
  echo "File copied successfully to the remote server."
fi

# Move the file to the desired directory on the remote server
echo "Moving the file to $REMOTE_PATH_BACKEND on the remote server..."
ssh -T nrt-$ENV <<EOF
  sudo mv ~/application-dev.yaml $REMOTE_PATH_BACKEND
EOF

if [ $? -ne 0 ]; then
  log_error "Failed to move the file to $REMOTE_PATH_BACKEND on the remote server."
  echo "Failed to move the file to $REMOTE_PATH_BACKEND on the remote server. Check logfile for details."
  exit 1
else
  echo "File moved successfully to $REMOTE_PATH_BACKEND on the remote server."
fi

# Exit the script
echo "Script execution completed."
exit 0

}
