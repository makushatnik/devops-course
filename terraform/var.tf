variable "server_port" {
	description = "The port the server will use"
	type = number
	default = 8080
}

variable "alb_port" {
	description = "The port the alb will use for HTTP"
	type = number
	default = 80
}

output "alb_dns_name" {
    description = "The domain name of the load balancer"
	value = aws_lb.balancer.dns_name
}