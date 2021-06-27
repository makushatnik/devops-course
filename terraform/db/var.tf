output "address" {
    description = "The database located at this address"
	value = aws_db_instance.database.address
}

output "port" {
    description = "The port of the database is listening on"
	value = aws_db_instance.database.port
}
