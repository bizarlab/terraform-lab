output "instance_password" {
  description = "Compute Password"
  value       = ["${random_string.instance_password.result}"]
}
