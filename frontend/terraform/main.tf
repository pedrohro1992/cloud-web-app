module "web_app" {
  source = "../modules"

  cluster_name = "cacetinho-sa-frontend"

  instance_type = "t2.micro"

  min_size = 1

  max_size = 1

  server_port = 80

  ssh_server_port = 22

  server_protocol = "TCP"

  health_check_type = "EC2"

}
