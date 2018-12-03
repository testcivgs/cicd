#!/bin/bash

# Treat unset variables as an error when substituting.
set -u

WORKSPACE_DIR=$(pwd)
ENVIRONMENT="dev"
TF_EXIT_CODE=0
SERVICE_NAME=""
DOCKER_TAG="latest"
MIN_TO_WAIT_DEPLOYMENT="5"
TF_SERVICE_PREFIX=""
CHECK_SERVICE="true"

#######################################################################
# Parse arguments

while [ $# -gt 0 ]
do
  case "$1" in
    --name)
      SERVICE_NAME="$2"
      shift 2
    ;;

    --prefix|--service-prefix-name)
      TF_SERVICE_PREFIX="$2"
      shift 2
    ;;

    --tag|--docker-tag)
      DOCKER_TAG="$2"
      shift 2
    ;;

    --env|--environment)
      ENVIRONMENT="$2"
      shift 2
    ;;

    --skip-service-check|--no-wait)
      CHECK_SERVICE="false"
      shift
    ;;

    *)
      # Non option argument
      break # Finish for loop
    ;;
  esac
done

TF_WORKSPACE_DIR="${WORKSPACE_DIR}/tf-live/${ENVIRONMENT}"


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

get_from_terragrunt() {
  _TF_DIR="$1"
  _TF_PATH="$2"

  pushd "$_TF_DIR" > /dev/null
  terragrunt output -json | python -c "import sys, json; print json.load(sys.stdin)['$_TF_PATH']['value']"
  popd > /dev/null
}

check_service() {
  _ECS_CLUSTER="$1"
  _TASK_DEFINITION="$2"
  _TASK_DEFINITION_ARN="$3"

  _SERVICE_STATUS="PENDING"
  _SERVICE_DEPLOYMENTS_COUNT="2"
  TOTAL_COUNT=$(( MIN_TO_WAIT_DEPLOYMENT*60/2 ))
  for ((i=1; i<=TOTAL_COUNT; i++)); do
      _SERVICE=$(aws ecs describe-services --services $_TASK_DEFINITION --cluster $_ECS_CLUSTER | python -c 'import sys, json; print json.dumps(json.load(sys.stdin)["services"][0])')
      _SERVICE_STATUS=$(echo $_SERVICE | python -c 'import sys, json; print json.load(sys.stdin)["status"]')
      _SERVICE_COUNT=$(echo $_SERVICE | python -c 'import sys, json; print json.load(sys.stdin)["runningCount"]')
      _SERVICE_PENDING_COUNT=$(echo $_SERVICE | python -c 'import sys, json; print json.load(sys.stdin)["pendingCount"]')
      _SERVICE_TASK_DEFENITION_ARN=$(echo $_SERVICE | python -c 'import sys, json; print json.load(sys.stdin)["taskDefinition"]')
      _SERVICE_DEPLOYMENTS=$(echo $_SERVICE | python -c 'import sys, json; print json.load(sys.stdin)["deployments"]')
      _SERVICE_DEPLOYMENTS_COUNT=$(echo $_SERVICE | python -c 'import sys, json; print len(json.load(sys.stdin)["deployments"])')

      info "Service status: $_SERVICE_STATUS"
      info "Service count: $_SERVICE_COUNT"
      info "Service pending count: $_SERVICE_PENDING_COUNT"
      info "Service task definition: $_SERVICE_TASK_DEFENITION_ARN"
      info "Service deployments: $_SERVICE_DEPLOYMENTS_COUNT"

      if [[ "$_SERVICE_DEPLOYMENTS_COUNT" = "1" ]]; then
        info "Successfully deployed a new task defenition: $_SERVICE_TASK_DEFENITION_ARN"
        return 0
      else
        info "More than 1 deployments are running:"
        info "$_SERVICE_DEPLOYMENTS"
        info "Will retry check in 2 sec again."
        sleep 2
      fi
  done

  error "Task defenition for service wasn't updated in $MIN_TO_WAIT_DEPLOYMENT minutes."
  return 1
}

# rollback_service() {
#   _ECS_CLUSTER="$1"
#   _SERVICE_NAME="$2"
#   _TASK_DEFINITION_JSON="$3"
#
#   tmp=$(mktemp)
#   echo "$_TASK_DEFINITION_JSON" > $tmp
#   info "Run rollback to previous task definition:"
#   info "$_TASK_DEFINITION_JSON"
#
#   info "Registering Task"
#   _TASK_NEW_DEFINITION=$(aws ecs register-task-definition --cli-input-json file://${tmp}) || {
#     error "Failed to create new task defenition."
#     return 1
#   }
#
#   _TASK_NEW_DEFINITION_ARN=$(echo $_TASK_NEW_DEFINITION | python -c 'import sys, json; print json.load(sys.stdin)["taskDefinition"]["taskDefinitionArn"]')
#   aws ecs update-service --cluster "$_ECS_CLUSTER" --service "$_SERVICE_NAME"  --task-definition "$_TASK_NEW_DEFINITION_ARN" || {
#     error "Failed to update service to a new task defenition"
#     return 1
#   }
#
#   return 0
# }


#######################################################################
# Validate settings

[[ -z "$SERVICE_NAME" ]] && {
  error "Service name is missed. Run script with option --name <SERVICE_NAME>"
  exit 1
}

[[ ! -d "${TF_WORKSPACE_DIR}/${SERVICE_NAME}" ]] && {
  error "TF configuration for service \"$SERVICE_NAME\" does not exist."
  exit 1
}

#######################################################################
# Program body

if [[ -z "$TF_SERVICE_PREFIX" ]]; then
  TF_SERVICE_PREFIX=$(echo $SERVICE_NAME | sed 's/-/_/g')
fi

eval export TF_VAR_${TF_SERVICE_PREFIX}_docker_tag=$DOCKER_TAG

pushd "$TF_WORKSPACE_DIR" > /dev/null
  ECS_CLUSTER=$(get_from_terragrunt ecs-cluster cluster_name)
  info "ECS Cluster: $ECS_CLUSTER"

  TASK_DEFINITION=$(get_from_terragrunt $SERVICE_NAME ${TF_SERVICE_PREFIX}_task_definition)
  info "Service task definition: $TASK_DEFINITION"

  TASK_DEFINITION_ARN=$(get_from_terragrunt $SERVICE_NAME ${TF_SERVICE_PREFIX}_task_definition_arn)
  info "Service task definition arn: $TASK_DEFINITION_ARN"

  #TASK_DEFINITION_JSON=$(aws ecs describe-task-definition --task-definition arn:aws:ecs:eu-west-2:431504048359:task-definition/dev_test:8)
  #TASK_DEFINITION_JSON_CLEAN="$(echo $TASK_DEFINITION_JSON| python -c 'import sys, json; task=json.load(sys.stdin)["taskDefinition"]; del task["status"]; del task["requiresAttributes"]; del task["taskDefinitionArn"]; del task["revision"]; print task')"

  # Get current service desired count
  DESIRED_COUNT=$(get_from_terragrunt $SERVICE_NAME ${TF_SERVICE_PREFIX}_desired_count)
  if [[ "0" == "$DESIRED_COUNT" ]]; then
    DESIRED_COUNT="1"
  fi
  eval export TF_VAR_${TF_SERVICE_PREFIX}_desired_count=$DESIRED_COUNT
  info "${SERVICE_NAME} desirect count: ${DESIRED_COUNT}"
  env | grep _desired_count
  # Create New Task Definition
  pushd "${TF_WORKSPACE_DIR}/${SERVICE_NAME}" > /dev/null
    terragrunt plan -detailed-exitcode || TF_EXIT_CODE=$?

  if (( 1 == $TF_EXIT_CODE )); then
    exit 1
  elif (( 0 == $TF_EXIT_CODE )); then
    info "Service is up to date. Nothing to change."
    popd > /dev/null
  else
    terragrunt apply -auto-approve || exit 1
    popd > /dev/null
    # Wait 5 sec to prevent aws api latency impact the check
    sleep 5

    if [[ "true" == "$CHECK_SERVICE" ]]; then
      check_service "$ECS_CLUSTER" "$TASK_DEFINITION" "$TASK_DEFINITION_ARN" || exit 1
    fi
  fi

  # Get New docker image version
  SERVICE_IMAGE_VERSION=$(get_from_terragrunt $SERVICE_NAME ${TF_SERVICE_PREFIX}_docker_tag)

  echo "${SERVICE_NAME}: $SERVICE_IMAGE_VERSION" > "${WORKSPACE_DIR}/current_build_description.txt"

popd > /dev/null
