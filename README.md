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

## Homework 6, 7

1.1) Use `gcloud` command to build `reddit-app` instance in GCE:
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

1.2) Use command `gcloud` to build `reddit-app` instance in GCE:
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

## Homework 8, 9

1.1) Use [HashiCorp Terraform](https://www.terraform.io/intro/index.html) to build `reddit-app` and `reddit-db` instances in GCE:
 - use [HashiCorp Packer](https://www.packer.io/intro/index.html) and `Bash` to build images with prepared installation

```bash
~$ packer build \
 -var 'machine_type=f1-micro' \
 -var 'project_id=infra-179717' \
 -var 'source_image=ubuntu-1604-xenial-v20170815a' \
./packer/db_shell.json

~$ packer build \
 -var 'machine_type=f1-micro' \
 -var 'project_id=infra-179717' \
 -var 'source_image=ubuntu-1604-xenial-v20170815a' \
./packer/app_shell.json
```
 - use required file `variables.tf` for _each module_ and _each environment_ with definition of needed variables
 - create an internal file `terraform.tfvars` with custom values of variables
```bash
project = "infra-179717"
public_key_path = "~/.ssh/otus_devops_appuser.pub"
private_key_path = "~/.ssh/otus_devops_appuser"
db_disk_image = "reddit-db-1505646807"
app_disk_image = "reddit-app-1505646464"
disk_image = "reddit-base-1505269146"
```
 - build instances
```bash
~/terraform/{prod | stage}$ terraform init
~/terraform/{prod | stage}$ terraform plan
~/terraform/{prod | stage}$ terraform apply
```
 - you can import existing infrastructure that were available in GCE and change state of [HashiCorp Terraform](https://www.terraform.io/intro/index.html)
 before `apply`; example: 
```bash
~/terraform/{prod | stage}$ terraform import module.vpc.google_compute_firewall.firewall_ssh default-allow-ssh
``` 
1.2) Use [Google Cloud Storage](https://cloud.google.com/storage/) to store a `terraform` state file
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

## Homework 10

Use [HashiCorp Packer](https://www.packer.io/intro/index.html) and [Red Hat Ansible](https://www.ansible.com) to build `reddit-app` and `reddit-db` images in GCE:
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
 ```bash
 ~$ gcloud compute firewall-rules create default-allow-ssh \
  --allow tcp:22 --priority=65534 \
  --description="Allow SSH connections" \
  --direction=INGRESS
 ```
 - use [HashiCorp Packer](https://www.packer.io/intro/index.html) templates with `[Red Hat Ansible](https://www.ansible.com) playbooks 
 (instead of bash scripts) to build images with prepared installations
 ```bash
~$packer build \
  -var 'machine_type=f1-micro' \
  -var 'project_id=infra-179717' \
  -var 'source_image=ubuntu-1604-xenial-v20170919' \
./packer/db_ansible.json

~$packer build \
  -var 'machine_type=f1-micro' \
  -var 'project_id=infra-179717' \
  -var 'source_image=ubuntu-1604-xenial-v20170919' \
./packer/app_ansible.json
 ```

## Homework 11, 12

1.1) Configure `reddit-app` and `reddit-db` instances in GCE
 - make an inventory file for with custom IP's
```bash
$ cat hosts
[app]
appserver ansible_ssh_host=35.195.190.123
[db]
dbserver ansible_ssh_host=35.189.224.149
```
 - make [Red Hat Ansible](https://www.ansible.com) common config file
```bash
~$ cat ansible.cfg
[defaults]
inventory = hosts
remote_user = appuser
private_key_file = ~/.ssh/otus_devops_appuser
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

1.2) Apply [Red Hat Ansible](https://www.ansible.com) playbooks
 - use 1 file and 1 playbook; need to choose host (app | db) and concreate tag (db-tag | app-tag | deploy-tag)
```bash
~/ansible$ ansible-playbook -i environments/stage/hosts reddit_app_db_one_playbook.yml --limit db --tags db-tag
~/ansible$ ansible-playbook -i environments/stage/hosts reddit_app_db_one_playbook.yml --limit app --tags app-tag
~/ansible$ ansible-playbook -i environments/stage/hosts reddit_app_db_one_playbook.yml --limit app --tags deploy-tag
```

 - or use 1 file and multiple playbooks; need to choose concreate tag (db-tag | app-tag | deploy-tag)
```bash
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags db-tag --check
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags db-tag
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags app-tag --check
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags app-tag
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags deploy-tag --check
~/ansible$ ansible-playbook reddit_app_db_multiple_playbooks.yml --tags deploy-tag
```

 - or use multiple files and multiple playbooks; nothing to choose, invoke one file only with ansible roles and environments
```bash
~/ansible$ ansible-playbook site.yml --check
~/ansible$ ansible-playbook site.yml
```

## Homework 13

[HashiCorp Vagrant](https://www.vagrantup.com/intro/index.html) like as [HashiCorp Terraform](https://www.terraform.io/intro/index.html) 
is a tool for building and managing virtual machine environments but in a single workflow.
[HashiCorp Terraform](https://www.terraform.io/intro/index.html) saves local files in `.terraform` and [HashiCorp Vagrant](https://www.vagrantup.com/intro/index.html) saves in `.vagrant`.

1.1) Use [HashiCorp Vagrant](https://www.vagrantup.com/intro/index.html) and [Oracle VirtualBox](https://www.virtualbox.org) 
(or MWare, Amazon EC2, LXC и libvirt) to create 2 virtual machines with declarative definitions: `dbserver` and `appserver`
 - don't do this but if you want to create new `Vagrantfile` or read more about configurations:
```bash
~/vagrant$ vagrant init 
 ```
 - create vm and show status information
```bash
~/vagrant$ vagrant up
~/vagrant$ vagrant status
~/vagrant$ vagrant box list
```
 - connect to each vm by `ssh`
```bash
~/vagrant$ vagrant ssh appserver
~/vagrant$ vagrant ssh dbserver
```
 - install [Red Hat Ansible](https://www.ansible.com) and required dependencies
```bash
~/vagrant$ pip install -r ./ansible/requirements.txt
~/vagrant$ molecule --version
molecule, version 2.1.0
~/vagrant$ ansible --version
ansible 2.3.2.0
```
 - [HashiCorp Vagrant](https://www.vagrantup.com/intro/index.html) generates dynamic inventory file
```bash
~/vagrant$ cat .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory
```
 - open internet browser by URL <http://10.10.10.20:9292> to check `appserver` 
 - at the end delete the instances of [Oracle VirtualBox](https://www.virtualbox.org)
```bash
~/vagrant$ vagrant destroy -f
==> appserver: Forcing shutdown of VM...
==> appserver: Destroying VM and associated drives...
==> dbserver: Forcing shutdown of VM...
==> dbserver: Destroying VM and associated drives...
```

1.2) Use [Testinfra](http://testinfra.readthedocs.io) to write unit tests in `Python` and 
[Metacloud Molecule](http://molecule.readthedocs.io/en/latest/porting.html) to test actual state of virtual instances 
configured by [Red Hat Ansible](https://www.ansible.com)
 - initialize scenario for role `db`
```bash
~/vagrant/roles/db$ molecule init scenario --scenario-name default -r db -d vagrant
```
 - create test instance by [HashiCorp Vagrant](https://www.vagrantup.com/intro/index.html) and connect by `ssh` to check instance
 ```bash
~vagrant/roles/db$ molecule create
~vagrant/roles/db$ molecule list
~vagrant/roles/db$ molecule login -h instance
``` 
  - apply inner molecule playbook and run tests
 ```bash
~vagrant/roles/db$ molecule converge
~vagrant/roles/db$ molecule verify
--> Test matrix

└── default
    └── verify
--> Scenario: 'default'
--> Action: 'verify'
--> Executing Testinfra tests found in /Users/dima/programming/git/otus/infra/vagrant/roles/db/molecule/default/tests/...
    ============================= test session starts ==============================
    platform darwin -- Python 2.7.14, pytest-3.2.3, py-1.4.34, pluggy-0.4.0
    rootdir: /Users/dima/programming/git/otus/infra/vagrant/roles/db/molecule/default, inifile:
    plugins: testinfra-1.6.3
collected 3 items
Verifier completed successfully.
```