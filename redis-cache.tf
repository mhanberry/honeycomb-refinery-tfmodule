# ---------------------------------------------------------------------------------------------------------------------
# CREATE REDIS CACHE FOR REFINERY NODE MANAGEMENT
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_elasticache_cluster" "honeycomb_refinery_cache" {
  cluster_id = "honeycomb-refinery-cache"
  engine = "redis"
  engine_version = "6.x"
  node_type = "cache.t3.micro"
  num_cache_nodes = 1
  parameter_group_name = aws_elasticache_parameter_group.honeycomb_refinery_cache_parameter_group.id
  subnet_group_name = aws_elasticache_subnet_group.honeycomb_refinery_cache_subnet_group.id
  port = 6379
}

resource "aws_elasticache_parameter_group" "honeycomb_refinery_cache_parameter_group" {
  name = "honeycomb-refinery-cache-parameter-group"
  family = "redis6.x"
}

resource "aws_elasticache_subnet_group" "honeycomb_refinery_cache_subnet_group" {
  name = "honeycomb-refinery-cache-subnet-group"
  subnet_ids = [aws_subnet.honeycomb_refinery_subnet.id]
}

resource "aws_elasticache_user" "honeycomb_refinery_cache_user" {
  user_id = "hcrUserId"
  user_name = "hcrUser"
  access_string = "on +@all"
  engine = "REDIS"
  passwords = [random_password.honeycomb_refinery_cache_password.result]
}

# ---------------------------------------------------------------------------------------------------------------------
# GENERATE A RANDOM PASSWORD FOR THE REDIS CACHE
# ---------------------------------------------------------------------------------------------------------------------

resource "random_password" "honeycomb_refinery_cache_password" {
  length = 16
  special = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}
