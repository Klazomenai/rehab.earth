variable "do_token" {}
variable "pvt_key" {}
variable "ssh_fingerprint" {}
variable "region" { default = "fra1" }
variable "size" { default = "4gb" }
variable "project" {}
variable "tz" {}
variable "base_snapshot_id" {}

variable "project_branch" {
  description = "Gitlab project branch"
  type = "string"
  default = "master"
}
