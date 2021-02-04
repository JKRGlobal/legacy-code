# jkr Scripts
This repository holds a collection of scripts that are used (across all sites that are accessible via VPN) to perform various functions; like installing applications, clearing DNS caches, setting up users etc.  

### Clone repository onto local Mac

1. Check for SSH public key
	`cat ~/.ssh/id_rsa.pub`
1. Create an SSH keypair if no public key exists	
	`ssh-keygen -t rsa`	
2. Copy the contents of the keypair to clipboard	
	`cat ~/.ssh/id_rsa.pub | pbcopy`
3. Setup a user account within Gitlab, and paste the SSH public key output (id_rsa.pub) into your user account (ssh keys)
4. Open Terminal
5. Create a new folder	
	`mkdir $newfolder`
6. Change directory to folder	
	`cd $newfolder`
7. Locally clone this repository	
	`git clone ssh://git@gitlab.corp.jkrglobal.com:2222/it/jkr-scripts.git`