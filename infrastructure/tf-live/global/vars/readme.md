# How to work with vars

## Add secure data
### Decrypt vars-vault.yml.encrypted to vars-vault.yml.decrypted
    ./generate-vars.sh --vault ~/.vault.txt --decrypt
### Edit vars-vault.yml.decrypted and vars.tf.j2
### Encrypt vars-vault.yml.decrypted to vars-vault.yml.encrypted
    ./generate-vars.sh --vault ~/.vault.txt --encrypt
### Commit vars-vault.yml.encrypted

## Run terragrunt
    ./generate-vars.sh --vault ~/.vault.txt
    terragrunt plan
    terragrunt apply
