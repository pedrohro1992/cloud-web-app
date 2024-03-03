resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.cluster_name}-key"
  public_key = tls_private_key.ssh_key.public_key_openssh

  provisioner "local-exec" {
    command = "echo '${tls_private_key.ssh_key.private_key_pem}' > ./'${var.cluster_name}-key'.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 './${var.cluster_name}-key'.pem"
  }

}
