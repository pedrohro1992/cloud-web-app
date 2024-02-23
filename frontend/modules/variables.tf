variable "cluster_name" {
  description = "The name to use for all the cluster resources"
  type        = string
}


variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
  type        = string
}

variable "min_size" {
  description = "The minimum number of EC2 instances in the ASG"
  type        = number

  validation {
    condition     = var.min_size > 0
    error_message = "ASGs can't be empty or we'll have an outage!"
  }

  validation {
    condition     = var.min_size <= 10
    error_message = "ASGs must have 10 or fewer instances to keep costs down"
  }
}

variable "max_size" {
  description = "The maximum numbe of the EC2 Instances in the ASG"
  type        = number
}


variable "custom_tags" {
  description = "Custom tags to set on the Instances in the ASG"
  type        = map(string)
  default     = {}
}

variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
}

variable "ssh_server_port" {
  description = "Port to ssh into the service"
  type        = number
}


variable "server_protocol" {
  description = "Protocol for the server"
  type        = string
}

variable "health_check_type" {
  description = "The type of health check to perform. Must be one of: EC2, ELB."
  type        = string
}

variable "user_data" {
  description = "The User Data script to run un each Instance at boot"
  type        = string
  default     = null
}
