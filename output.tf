
output "my_password" {
  value = random_password.my_password.result
  sensitive = true
}