#!/bin/bash

# Treat unset variables as an error when substituting.
set -u

JOB_NAME=""
JENKINS_USER=""
JENKINS_API_TOKEN=""
JENKINS_HOST="jenkins.mgmt.connected.express"
JENKINS_PROTOCOL="http"
FORCE_EXPORT="false"
JOB_EXIST="false"

#######################################################################
# Parse arguments

while [ $# -gt 0 ]
do
  case "$1" in
    --name)
      JOB_NAME="$2"
      shift 2
    ;;

    --user)
      JENKINS_USER="$2"
      shift 2
    ;;

    --token)
      JENKINS_API_TOKEN="$2"
      shift 2
    ;;

    --host)
      JENKINS_HOST="$2"
      shift 2
    ;;

    --protocol)
      JENKINS_PROTOCOL="$2"
      shift 2
    ;;

    --force)
      FORCE_EXPORT="true"
      shift
    ;;

    *)
      # Non option argument
      break # Finish for loop
    ;;
  esac

done


#######################################################################
# Subroutines

error() {
  echo "[ERROR] $@" >&2
}

warn() {
  echo "[WARN] $@" >&2
}

info() {
  echo "[INFO] $@"
}


#######################################################################
# Validate settings

[[ -z "$JOB_NAME" ]] && {
  error "Job name is missed. Run script with option --name <JOB_NAME>"
  exit 1
}

[[ -z "$JENKINS_USER" ]] && {
  error "Username to connect to Jenkins is missed. Run script with option --user <JENKINS_USER>"
  exit 1
}

[[ -z "$JENKINS_API_TOKEN" ]] && {
  error "API token to connect to Jenkins is missed. Run script with option --token <API_TOKEN>"
  exit 1
}

#######################################################################
# Program body

JENKINS_URL="${JENKINS_PROTOCOL}://${JENKINS_USER}:${JENKINS_API_TOKEN}@${JENKINS_HOST}"
JENKINS_JOB_CONFIG_FILE_URL="${JENKINS_URL}/job/${JOB_NAME}/config.xml"
JENKINS_CREATE_JOB_URL="${JENKINS_URL}/createItem?name=${JOB_NAME}"
JENKINS_JOB_FILE_PATH="${JOB_NAME}/config.xml"

if [[ ! -f "$JENKINS_JOB_FILE_PATH" ]]; then
  error "Can't find Jenkins job file: \"${JENKINS_JOB_FILE_PATH}\"."
  exit 1
fi

# Verify if job already exist
HTTP_CODE="$(curl -s -w "%{http_code}" -o /dev/null "$JENKINS_JOB_CONFIG_FILE_URL")"
ERROR_MESSAGE="Jenkins job \"${JOB_NAME}\" already exists."
if [[ "200" == "$HTTP_CODE" ]] && [[ "$FORCE_EXPORT" == "true" ]]; then
  warn "$ERROR_MESSAGE Overwriting the Job."
  JENKINS_CREATE_JOB_URL="$JENKINS_JOB_CONFIG_FILE_URL"
elif [[ "200" == "$HTTP_CODE" ]] && [[ "$FORCE_EXPORT" == "false" ]]; then
  error "${ERROR_MESSAGE}. Run command with --force to overwrite the job."
  exit 1
fi

echo "Exporting job \"${JOB_NAME}\" to Jenkins: \"${JENKINS_PROTOCOL}://${JENKINS_HOST}\""
# https://wiki.jenkins-ci.org/display/JENKINS/Remote+access+API#RemoteaccessAPI-CSRFProtection
CRUMB=$(curl -s "${JENKINS_URL}/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,\":\",//crumb)")

curl -k -X POST "$JENKINS_CREATE_JOB_URL" \
    --header "Content-Type: application/xml" \
    --header "$CRUMB" -d @"${JENKINS_JOB_FILE_PATH}"