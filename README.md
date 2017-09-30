Infra
=======


DevOps course, practices with [Google Cloud Platform](https://cloud.google.com/).

1.1) Project has scripts for manual setup:
 - install Ruby `install_ruby.sh`
 - install MongoDB `install_mongodb.sh`
 - deploy application 'reddit' from Artemmkin `scripts/deploy.sh`

1.2) Project has scripts to make automatic setup at the time startup new instance:
 - startup script `scripts/startup_script1_1.sh`
 - inner script `scripts/startup_script1_2.sh` with main tasks

--- 
**Homework 6, 7**

2.1) Use `gcloud` command to build `reddit-app` instance in GCE:
 - use default image from GCE
 - use startup script to make prepare installations

```bash 
$ gcloud compute instances create 
 --boot-disk-size=10GB \
 --image=ubuntu-1604-xenial-v20170815a \
 --image-project=ubuntu-os-cloud \
 --machine-type=g1-small \
 --tags puma-server \
 --restart-on-failure 
 --zone=europe-west1-b \
 --metadata-from-file startup-script=./startup_script1_1.sh 
reddit-app
```

2.2) Use command `gcloud` to build `reddit-app` instance in GCE:
- use [HashiCorp Packer](https://www.packer.io/intro/index.html) to build image with prepared installations
- use a custom bake-image

```bash 
$ packer build \
 -var 'machine_type=f1-micro' \
 -var 'project_id=practice-devops-gcp-1' \
 -var 'source_image=ubuntu-1604-xenial-v20170815a' \
./packer/immutable.json

$ gcloud compute instances create \
 --image=reddit-base-2-1505095462 \
 --image-project=practice-devops-gcp-1 \
 --machine-type=g1-small \
 --tags puma-server \
 --restart-on-failure \
 --zone=europe-west1-b \
reddit-app
```

--- 
**Homework 8, 9**

3.1) Use [HashiCorp Terraform](https://www.terraform.io/intro/index.html) to build `reddit-app` and `reddit-db` instances in GCE:
 - use [HashiCorp Packer](https://www.packer.io/intro/index.html) to build images with prepared installation

```bash  
~$ packer build \
 -var 'machine_type=f1-micro' \
 -var 'project_id=infra-179717' \
 -var 'source_image=ubuntu-1604-xenial-v20170815a' \
./packer/db.json

~$ packer build \
 -var 'machine_type=f1-micro' \
 -var 'project_id=infra-179717' \
 -var 'source_image=ubuntu-1604-xenial-v20170815a' \ 
./packer/app.json
``` 
 - use required file `variables.tf` for _each module_ and _each environment_ with definition of needed variables
 - create an internal file `terraform.tfvars` with custom values of variables
```bash
project = "infra-179717"
public_key_path = "~/.ssh/otus_devops_appuser.pub"
private_key_path = "~/.ssh/otus_devops_appuser"
db_disk_image = "reddit-db-1505646807"
app_disk_image = "reddit-app-1505646464"
disk_image = "reddit-base-3-1505269146"
``` 
 - build instances
```bash  
~/terraform/{prod | stage}$ terraform init
~/terraform/{prod | stage}$ terraform plan
~/terraform/{prod | stage}$ terraform apply
```
 
3.2) Use [Google Cloud Storage](https://cloud.google.com/storage/) to store a `terraform` state file
 - create file `backend.tf` next to `main.tf`
```bash
terraform {
  backend "gcs" {
    bucket  = "infra-179717-bucket"
    path    = "infra/terraform.tfstate"
    project = "infra-179717"
    region  = "europe-west1"
  }
}
``` 
 - create storage bucket
```bash  
~$ gsutil mb -c regional -l europe-west1 -p infra-179717 gs://infra-179717-bucket
Creating gs://infra-179717-bucket/...

~$ gsutil ls
gs://infra-179717-bucket/
```
 - build instances
```bash  
~/terraform/{prod | stage}$ terraform init
~/terraform/{prod | stage}$ terraform plan
~/terraform/{prod | stage}$ terraform apply
```


Do not forget delete resources
```bash  
~/terraform/{prod | stage}$ terraform destroy

~$ gsutil rm -r gs://infra-179717-bucket/
Removing gs://infra-179717-bucket/infra/terraform.tfstate#1505901677420946...
/ [1 objects]
Operation completed over 1 objects.
Removing gs://infra-179717-bucket/...
```

--- 
**Homework 10**

4) Use [HashiCorp Packer](https://www.packer.io/intro/index.html) and [Red Hat Ansible](https://www.ansible.com) to build `reddit-app` and `reddit-db` images in GCE:
 - install `Ansible` and required dependencies
```bash   
~$ pip install -r ./ansible/requirements.txt
~$ ansible --version
ansible 2.3.2.0
``` 
 - check `firewall-rules`:
```bash  
~$ gcloud compute firewall-rules list
NAME                    NETWORK  DIRECTION  PRIORITY  ALLOW                         DENY
default-allow-icmp      default  INGRESS    65534     icmp
default-allow-internal  default  INGRESS    65534     tcp:0-65535,udp:0-65535,icmp
default-allow-rdp       default  INGRESS    65534     tcp:3389
default-allow-ssh       default  INGRESS    65534     tcp:22
``` 
 - create `default-allow-ssh` if you do not have this one
 ```ssh  
 ~$ gcloud compute firewall-rules create default-allow-ssh \ 
  --allow tcp:22 --priority=65534 \ 
  --description="Allow SSH connections" \ 
  --direction=INGRESS
 ``` 
 - use `Packer` templates with `Ansible` playbooks (instead of bash scripts) to build images with prepared installations
 ```bash 
~$packer build \ 
  -var 'machine_type=f1-micro' \
  -var 'project_id=infra-179717' \
  -var 'source_image=ubuntu-1604-xenial-v20170919' \
./packer/db.json

~$packer build \
  -var 'machine_type=f1-micro' \
  -var 'project_id=infra-179717' \
  -var 'source_image=ubuntu-1604-xenial-v20170919' \
./packer/app.json
 ```

 ``` 

--- 
**Homework 11**

5) Configure `reddit-app` and `reddit-db` images in GCE
 - make an inventory file for with custom IP's
```ssh  
$ cat hosts
[app]
appserver ansible_ssh_host=35.195.190.123
[db]
dbserver ansible_ssh_host=35.189.224.149
``` 
 - make [Red Hat Ansible](https://www.ansible.com) common config file
```ssh 
~$ cat ansible.cfg
[defaults]
inventory = hosts
remote_user = appuser
private_key_file = ~/.ssh/appuser
host_key_checking = False

~$ ansible all -m ping
dbserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
appserver | SUCCESS => {
"changed": false,
"ping": "pong"
}
``` 

 - define [Red Hat Ansible](https://www.ansible.com) playbook
