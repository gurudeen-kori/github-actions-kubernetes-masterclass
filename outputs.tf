output "instance_id" {
  value = aws_instance.my_instance[0].id
}

output "public_ip" {
  value = aws_instance.my_instance[0].public_ip
}

output "private_ip" {
  value = aws_instance.my_instance[0].private_ip
}

output "instance_state" {
  value = aws_instance.my_instance[0].instance_state
}

output "ssh_command" {
  value = "ssh -i terra-automate-key ubuntu@${aws_instance.my_instance[0].public_ip}"
}