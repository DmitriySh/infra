Infra
=======


DevOps course, GCP practice 6.

Project has scripts for manual setup:
 - install Ruby `install_ruby.sh`
 - install MongoDB `install_mongodb.sh`
 - deploy application 'reddit' from Artemmkin `deploy.sh`

Project has scripts to make automatic setup at the time startup new instance:
 - startup script `startup_script1.sh`
 - inner script `startup_script2.sh` with main tasks

Use command to build `reddit-app` instance in GCE:
 - use default image from GCE
 - use startup script to make prepare installations
`gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file startup-script=./startup_script1.sh reddit-app`

- use a custom image with installed software
`gcloud compute instances create --boot-disk-size=10GB --image=reddit-base-1505047437 --image-project=practice-devops-gcp-1 --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b reddit-app`
