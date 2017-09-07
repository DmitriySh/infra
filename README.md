Infra
=======


DevOps course, GCP practice 6.

Project has script for each stesps:
 - install Ruby `install_ruby.sh`
 - install MongoDB `install_mongodb.sh`
 - deploy application 'reddit' from Artemmkin `deploy.sh`

Project has script to build instance in GCP and start service on startup; scripts:
 - startup script `startup_script1.sh`
 - inner script from git repository `startup_script2.sh`

Use command:
`gcloud compute instances create --boot-disk-size=10GB --image=ubuntu-1604-xenial-v20170815a --image-project=ubuntu-os-cloud --machine-type=g1-small --tags puma-server --restart-on-failure --zone=europe-west1-b --metadata-from-file startup-script=./startup_script1.sh reddit-app`
