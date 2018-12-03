#!/bin/bash

VALUT_PASSWORD_FILE="~/.vault.txt"
DECRYPT_FILE="false"
ENCRYPT_FILE="false"
GENERATE_VARS_FILE="true"


#######################################################################
# Parse arguments

while [ $# -gt 0 ]
do
  case "$1" in
    --vault)
      VALUT_PASSWORD_FILE="$2"
      shift 2
    ;;

    --decrypt)
      DECRYPT_FILE="true"
      ENCRYPT_FILE="false"
      GENERATE_VARS_FILE="false"
      shift
    ;;

    --encrypt)
      ENCRYPT_FILE="true"
      DECRYPT_FILE="false"
      GENERATE_VARS_FILE="false"
      shift
    ;;
    *)
      # Non option argument
      break # Finish for loop
    ;;
  esac

done


#######################################################################
# Program body

if [[ "true" == "$ENCRYPT_FILE" ]]; then
  ansible-vault encrypt --vault-password-file $VALUT_PASSWORD_FILE --output=vars-vault.yml.encrypted vars-vault.yml.decrypted
  exit 0
fi

if [[ "true" == "$DECRYPT_FILE" ]] || [[ "true" == "$GENERATE_VARS_FILE" ]]; then
  ansible-vault decrypt --vault-password-file $VALUT_PASSWORD_FILE --output=vars-vault.yml.decrypted vars-vault.yml.encrypted
fi

if [[ "true" == "$GENERATE_VARS_FILE" ]]; then
  echo "Generate vars.tf"
  j2 -f yaml vars.tf.j2 vars-vault.yml.decrypted > vars.tf
fi
