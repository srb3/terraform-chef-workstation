locals {
  attribute_parser = templatefile("${path.module}/templates/attribute_parser.rb", {})
  # below is a workarround for this bug: https://github.com/hashicorp/terraform/issues/21917 
  # once it is fixed this can be tidied up
  a2_code = var.automate_module != "" ? var.automate_module : jsonencode({"url" = [var.automate_url], "admin_user" = [var.automate_user], "token" = [var.automate_token] })
  code = var.chef_module != "" ? var.chef_module : jsonencode({"node_name" = [var.workstation_user_name], "client_pem" = [var.workstation_user_pem], "validation_pem" = [var.workstation_org_pem], "org_url" = [var.workstation_org_url]})

  ips = distinct(compact(concat(list(var.ip), var.ips)))
  user_names = var.user_name != "" ? [ for i in range(var.instance_count) : var.user_name ] : var.user_names
  user_passes = var.user_pass != "" ? [ for i in range(var.instance_count) : var.user_pass ] : var.user_passes
  user_private_keys = var.user_private_key != "" ? [ for i in range(var.instance_count) : var.user_private_key ] : var.user_private_keys
  instance_count = var.instance_count # should be `length(local.ips)` but their is a terrafrom issue for this https://github.com/hashicorp/terraform/issues/4149

  cmd            = var.system_type == "linux" ? "bash" : "powershell.exe"
  chef_repo_path = var.system_type == "linux" ? var.linux_chef_repo_path : var.windows_chef_repo_path 
  git_repo_path  = var.system_type == "linux" ? var.linux_git_repo_path : var.windows_git_repo_path 
  tmp_path       = var.system_type == "linux" ? "${var.linux_tmp_path}/${var.working_directory}" : "${var.windows_tmp_path}/${var.working_directory}"
  script_name    = var.system_type == "linux" ? var.linux_workstation_script_name : var.windows_workstation_script_name 
  restart_name   = var.system_type == "linux" ? var.linux_restart_workstation_script_name : var.windows_restart_workstation_script_name 
  jq_url         = var.system_type == "linux" ? var.jq_linux_url : var.jq_windows_url
  mkdir          = var.system_type == "linux" ? "mkdir -p" : "${local.cmd} New-Item -ItemType Directory -Force -Path"
  setup_cmd      = var.system_type == "linux" ? "${local.tmp_path}/${local.script_name}" : "Invoke-Expression ${local.tmp_path}/${local.script_name} > ${local.tmp_path}/workstation_setup_script.log 2>&1"
  restart_cmd    = var.system_type == "linux" ? "${local.tmp_path}/${local.restart_name}" : "Invoke-Expression ${local.tmp_path}/${local.restart_name} > ${local.tmp_path}/workstation_restart_script.log 2>&1"
  urls           = length(var.urls) > 0 ? join(" ", formatlist("\"%s\"", var.urls)) : ""

  workstation_restart = templatefile("${path.module}/templates/restart_workstation_file", {
    tmp_path                    = local.tmp_path,
    system                      = var.system_type
  })

  workstation_servers_module = templatefile("${path.module}/templates/servers_module", {
    bootstrap_github_user       = var.bootstrap_github_user,
    bootstrap_github_email      = var.bootstrap_github_email,
    bootstrap_client_version    = var.bootstrap_client_version,
    bootstrap_winrm_username    = var.bootstrap_winrm_username,
    bootstrap_winrm_password    = var.bootstrap_winrm_password,
    bootstrap_ssh_username      = var.bootstrap_ssh_username,
    bootstrap_ssh_key_path      = var.bootstrap_ssh_key_path,
    bootstrap_win_ips           = var.bootstrap_win_ips,
    bootstrap_lin_ips           = var.bootstrap_lin_ips,
    bootstrap_dev_count         = var.bootstrap_dev_count,
    bootstrap_stage_count       = var.bootstrap_stage_count,
    bootstrap_prod_count        = var.bootstrap_prod_count,
    github_ssh_key              = var.github_ssh_key,
    server_ssh_key              = var.server_ssh_key,
    automate_url                = length(jsondecode(local.a2_code)["url"]) > 0 ? jsondecode(local.a2_code)["url"][0] : "",
    automate_user               = length(jsondecode(local.a2_code)["admin_user"]) > 0 ? jsondecode(local.a2_code)["admin_user"][0] : "",
    automate_token              = length(jsondecode(local.a2_code)["token"]) > 0 ? jsondecode(local.a2_code)["token"][0] : "",
    src_repo_path               = var.bootstrap_src_repo_path,
    chef_repo_path              = var.bootstrap_chef_repo_path,
    chef_server_ssl_verify_mode = var.chef_server_ssl_verify_mode,
    workstation_user_name       = length(jsondecode(local.code)["node_name"]) > 0 ? jsondecode(local.code)["node_name"][0] : "",
    workstation_user_pem        = length(jsondecode(local.code)["client_pem"]) > 0 ? jsondecode(local.code)["client_pem"][0] : "",
    workstation_org_pem         = length(jsondecode(local.code)["validation_pem"]) > 0 ? jsondecode(local.code)["validation_pem"][0] : "",
    workstation_org_url         = length(jsondecode(local.code)["org_url"]) > 0 ? jsondecode(local.code)["org_url"][0] : ""

  })

  workstation_setup = templatefile("${path.module}/templates/setup_workstation_file", {
    data                        = local.code,
    chef_repo_path              = local.chef_repo_path,
    chef_server_ssl_verify_mode = var.chef_server_ssl_verify_mode,
    tmp_path                    = local.tmp_path,
    jq_url                      = local.jq_url,
    workstation_user_name       = length(jsondecode(local.code)["node_name"]) > 0 ? jsondecode(local.code)["node_name"][0] : ""
    workstation_user_pem        = length(jsondecode(local.code)["client_pem"]) > 0 ? jsondecode(local.code)["client_pem"][0] : ""
    workstation_org_pem         = length(jsondecode(local.code)["validation_pem"]) > 0 ? jsondecode(local.code)["validation_pem"][0] : ""
    workstation_org_url         = length(jsondecode(local.code)["org_url"]) > 0 ? jsondecode(local.code)["org_url"][0] : ""
    berksfiles                  = var.berksfiles,
    policyfiles                 = var.policyfiles,
    environments                = var.environments,
    roles                       = var.roles,
    github_cookbooks            = var.github_cookbooks,
    github_ssh_key              = var.github_ssh_key,
    server_ssh_key              = var.server_ssh_key,
    github_repos_path           = local.git_repo_path,
    github_repos                = var.github_repos,
    system                      = var.system_type,
    urls                        = local.urls,
    wait_for_base               = var.wait_for_base,
    module_input                = var.module_input
  })

}

resource "null_resource" "setup_workstation" {

  triggers = {
    berksfiles   = md5(jsonencode(var.berksfiles))
    policyfiles  = md5(jsonencode(var.policyfiles))
    environments = md5(jsonencode(var.environments))
    roles        = md5(jsonencode(var.roles))
    cookbooks    = md5(jsonencode(var.github_cookbooks))
    servers      = md5(jsonencode(local.workstation_servers_module))
  }
  count = local.instance_count

  connection {
    type        = var.system_type == "windows" ? "winrm" : "ssh"
    user        = local.user_names[count.index]
    password    = length(local.user_passes) > 0 ? local.user_passes[count.index] : null
    private_key = length(local.user_private_keys) > 0 ? file(local.user_private_keys[count.index]) : null
    host        = local.ips[count.index] 
  }

  provisioner "remote-exec" {
    inline = [
      "${local.mkdir} ${local.tmp_path}"
    ]
  }

  provisioner "file" {
    content     = local.attribute_parser
    destination = "${local.tmp_path}/attribute_parser.rb"
  }

  provisioner "file" {
    content     = local.workstation_servers_module
    destination = "${local.tmp_path}/servers.rb"
  }

  provisioner "file" {
    content     = local.workstation_setup
    destination = "${local.tmp_path}/${local.script_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "${local.cmd} ${local.setup_cmd}"
    ]
  }
}

resource "null_resource" "reboot_workstation" {

  depends_on = [null_resource.setup_workstation]

  count = var.restart == true ? local.instance_count : 0
  connection {
    type        = var.system_type == "windows" ? "winrm" : "ssh"
    user        = local.user_names[count.index]
    password    = length(local.user_passes) > 0 ? local.user_passes[count.index] : null
    private_key = length(local.user_private_keys) > 0 ? file(local.user_private_keys[count.index]) : null
    host        = local.ips[count.index] 
  }

  provisioner "file" {
    content     = local.workstation_restart
    destination = "${local.tmp_path}/${local.restart_name}"
  }

  provisioner "remote-exec" {
    inline = [
      "${local.cmd} ${local.restart_cmd}"
    ]
    on_failure = "continue"
  }
}
