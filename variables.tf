################## connection #####################
variable "ips" {
  description = "A list of ip addresses where we will setup a chef workstation"
  type        = list
  default     = []
}

variable "ip" {
  description = "A list of ip addresses where we will setup a chef workstation"
  type        = string
  default     = ""
}

variable "instance_count" {
  description = "The number of instances that will setup a chef workstation"
  type        = number
}

variable "user_name" {
  description = "The ssh or winrm user name used to access the ip addresses provided"
  type        = string
  default     = ""
}

variable "user_names" {
  description = "A list of ssh or winrm user names used to access the ip addresses provided"
  type        = list(string)
  default     = []
}

variable "user_pass" {
  description = "The ssh or winrm user password used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "user_passes" {
  description = "A list of ssh or winrm user passwords used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = list(string)
  default     = []
}

variable "user_private_key" {
  description = "The user key used to access the ip addresses (either user_pass or user_private_key needs to be set)"
  type        = string
  default     = ""
}

variable "user_private_keys" {
  description = "A list of user keys used to access the ip addresses (either user_pass/s or user_private_key/s needs to be set)"
  type        = list(string)
  default     = []
}

############ misc ###############################

variable "system_type" {
  description = "The system type linux or windows"
  type        = string
  default     = "linux"
}

variable "jq_linux_url" {
  description = "A url to a jq binary to download, used in the install process"
  type        = string
  default     = "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64"
}

variable "jq_windows_url" {
  description = "A url to a jq binary to download, used in the install process"
  type        = string
  default     = "https://github.com/stedolan/jq/releases/download/jq-1.6/jq-win64.exe"
}

variable "linux_tmp_path" {
  description = "The location of a temp directory to store install scripts on"
  type        = string
  default     = "/var/tmp"
}

variable "windows_tmp_path" {
  description = "The location of a temp directory to store install scripts on"
  type        = string
  default     = "C:\\chef_workstation"
}

variable "working_directory" {
  description = "The directory to hold the setup code"
  type        = string
  default     = "workstation_setup"
}

variable "linux_restart_workstation_script_name" {
  description = "The name to give the chef workstation restart script"
  type        = string
  default     = "chef_workstation_restart.sh"
}

variable "windows_restart_workstation_script_name" {
  description = "The name to give the chef workstation restart script"
  type        = string
  default     = "chef_workstation_restart.ps1"
}

variable "linux_workstation_script_name" {
  description = "The name to give the chef workstation setup script"
  type        = string
  default     = "chef_workstation_setup.sh"
}

variable "windows_workstation_script_name" {
  description = "The name to give the chef workstation setup script"
  type        = string
  default     = "chef_workstation_setup.ps1"
}

############ populate server options ############

variable "linux_chef_repo_path" {
  description = "The path to the chef repo, this path is created and populated with berksfiles / policyfiles, the workstation uses pem, the org validator pem, and the knife.rb"
  type        = string
  default     = "workspace/chef-repo"
}

variable "windows_chef_repo_path" {
  description = "The path to the chef repo, this path is created and populated with berksfiles / policyfiles, the workstation uses pem, the org validator pem, and the knife.rb"
  type        = string
  default     = "Desktop\\workspace\\chef-repo"
}

variable "bootstrap_chef_repo_path" {
  description = "The path to the chef repo, this path is created and populated with berksfiles / policyfiles, the workstation uses pem, the org validator pem, and the knife.rb"
  type        = string
  default     = "chef-repo"
}

variable "bootstrap_src_repo_path" {
  description = "The path to clone ad hock github repos to"
  type        = string
  default     = "src"
}

variable "workstation_user_name" {
  description = "The name of a chef user, used for workstation -> chef server interactions, can be left out if using the output of the srb3 chef server module in the chef_module variable"
  type        = string
  default     = ""
}

variable "workstation_user_pem" {
  description = "The content of the chef users client.pem (created at the same time as the user), can be left out if using the output of the srb3 chef server module in the chef_module variable"
  type        = string
  default     = ""
}

variable "workstation_org_pem" {
  description = "The content of the chef orgs client.pem (created at the same time as the org), can be left out if using the output of the srb3 chef server module in the chef_module variable"
  type        = string
  default     = ""
}

variable "workstation_org_url" {
  description = "The url to the chef users chef organisation on the chef server e.g. https://demo-chef-server-0.demo.net/organizations/acmecorp, can be left out if using the output of the srb3 chef server module in the chef_module variable"
  type        = string
  default     = ""
}

variable "chef_server_ssl_verify_mode" {
  description = "The ssl verify mode to use, if using self signed certs use :verify_none"
  type        = string
  default     = ":verify_none"
}

variable "chef_module" {
  description = "The jsonencoded output of the https://registry.terraform.io/modules/srb3/chef-server/linux module. If you are not using this module then you need to specify workstation_user_name workstation_user_pem workstation_org_pem and workstation_org_url"
  type       = string
  default    = ""
}

variable "berksfiles" {
  description = "A list of Maps used to populate each berksfile"
  type        = string
  default     = "[]"
}

variable "policyfiles" {
  description = "A list of Maps used to populate each policyfile" 
  type        = string
  default     = "[]"
}

variable "environments" {
  description = "A list of Maps used to populate each environments"
  type        = string
  default     = "[]"
}

variable "roles" {
  description = "A list of Maps used to populate each environments"
  type        = string
  default     = "[]"
}

variable "github_cookbooks" {
  description = "A json encoded string list of cookbooks to clone from github"
  type        = string
  default     = "[]"
}

########### misc options ############## 

variable "wait_for_base" {
  description = "Should we wait for the setup.lock file to be created" 
  type        = bool
  default     = true
}

variable "restart" {
  description = "Should we initiate a restart at the end of the module"
  type        = bool
  default     = false
}

variable "github_ssh_key" {
  description = "The content of a ssh private key, used to auth with github"
  type        = string
  default     = ""
}

variable "server_ssh_key" {
  description = "The content of a ssh private key, used to auth with linux servers"
  type        = string
  default     = ""
}

variable "linux_git_repo_path" {
  description = "A directory name in the users home directory to create the chef repo"
  type        = string
  default     = "workspace/src"
}

variable "windows_git_repo_path" {
  description = "A directory name in the users home directory to create the chef repo"
  type        = string
  default     = "Desktop\\workspace\\src"
}

variable "github_repos" {
  description = "A json encoded string list of repos to clone from github"
  type        = string
  default     = "[]"
}

variable "urls" {
  description = "A list of urls for use with a google chrome desktop shortcut"
  type        = list
  default     = []
}

########### bootstrap demo options #####

variable "bootstrap_client_version" {
  description = "A version of the chef client to bootstrap nodes with"
  type        = string
  default     = "latest"
}

variable "bootstrap_winrm_username" {
  description = "The winrm username"
  type        = string
  default     = "chef"
}

variable "bootstrap_winrm_password" {
  description = "The password for the winrm user"
  type        = string
  default     = "P@55w0rd1"
}

variable "bootstrap_ssh_username" {
  description = "The username to use for ssh to workshop nodes"
  type        = string
  default     = "chef"
}

variable "bootstrap_ssh_key_path" {
  description = "The path to an ssh key to use for auth to workshop nodes"
  type        = string
  default     = "~/.ssh/server.pem"
}

variable "bootstrap_win_ips" {
  description = "A list of ip addresses that map to the windows workshop servers"
  type        = list
  default     = []
}

variable "bootstrap_lin_ips" {
  description = "A list of ip addresses that map to the linux workshop servers"
  type        = list
  default     = []
}

variable "bootstrap_dev_count" {
  description = "the number of instnaces to designate in the development environment (windows, linux)"
  type        = number
  default     = 1
}

variable "bootstrap_stage_count" {
  description = "the number of instnaces to designate in the staging environment (windows, linux)"
  type        = number
  default     = 2
}

variable "bootstrap_prod_count" {
  description = "the number of instnaces to designate in the production environment from each pool (windows, linux)"
  type        = number
  default     = 2
}

variable "bootstrap_github_user" {
  description = "the github username to use for the demo environment"
  type        = string
  default     = "jdoe"
}

variable "bootstrap_github_email" {
  description = "the email to use for the github account"
  type        = string
  default     = "jdoe@mail.com"
}

variable "automate_url" {
  description = "The url to chef automate"
  type        = string
  default     = ""
}

variable "automate_user" {
  description = "The username for accessing automate"
  type        = string
  default     = ""
}

variable "automate_token" {
  description = "The token for accessing chef automate"
  type        = string
  default     = ""
}

variable "automate_module" {
  description = "The jsonencoded output of the https://registry.terraform.io/modules/srb3/chef-automate/linux module. If you are not using this module then you need to specify automate_url, automate_user and automate_token variables"
  type       = string
  default    = ""
}
########### module input ##############

variable "module_input" {
  description = "A string input to the module, used to enforce module ordering. make this input the putput from a dependant module"
  type        = string
  default     = "no_dependency"
}
