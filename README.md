Infra
=======


DevOps course, GCP practice 6.

Project has script for:
 - install Ruby
 - install MongoDB
 - deploy application 'reddit' (Artemmkin)

Use command:
`./gcloud compute instances create 
--boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a 
--image-project=ubuntu-os-cloud --machine-type=g1-small 
--tags puma-server --restart-on-failure --zone=europe-west1-b 
--metadata-from-file startup-script=./startup_script.sh reddit-app`

