# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLUSTER NETWORK RESOURCES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_vpc" "honeycomb_refinery_vpc" {
  cidr_block = var.vpc_cidr
  tags = var.tags
}

resource "aws_subnet" "honeycomb_refinery_subnet" {
  vpc_id = aws_vpc.honeycomb_refinery_vpc.id
  cidr_block = var.subnet_cidr
  tags = var.tags
}

resource "aws_network_interface" "honeycomb_refinery_network_interface" {
  count = var.node_count
  subnet_id = aws_subnet.honeycomb_refinery_subnet.id
  tags = var.tags
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE CLUSTER NODES
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_instance" "honeycomb_refinery_node" {
  metadata_options {
    http_endpoint = "enabled"
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  network_interface {
    network_interface_id = aws_network_interface.honeycomb_refinery_network_interface[count.index].id
    device_index = 0
  }

  count = var.node_count
  ami = "ami-052efd3df9dad4825"
  instance_type = var.instance_type
  tags = var.tags
  
  user_data = <<-EOF
    #!/bin/bash

    export REFINERY_REDIS_HOST="${aws_elasticache_cluster.honeycomb_refinery_cache.cache_nodes.0.address}:${aws_elasticache_cluster.honeycomb_refinery_cache.port}"
    export REFINERY_REDIS_PASSWORD="${random_password.honeycomb_refinery_cache_password.result}"
    export REFINERY_REDIS_USERNAME="hcrUser"

    mkdir -p /etc/refinery

    if [ ! -f /etch/refinery/refinery.toml ]; then
      echo "${file(var.refinery_config_file)}" > /etc/refinery/refinery.toml
    fi

    if [ ! -f /etch/refinery/rules.toml ]; then
      echo "${file(var.refinery_rules_file)}" > /etc/refinery/rules.toml
    fi

    if [ ! -f refinery_${var.refinery_version}_amd64.deb ]; then
      curl -L -O https://github.com/honeycombio/refinery/releases/download/latest/refinery_${var.refinery_version}_amd64.deb
      dpkg -i refinery_${var.refinery_version}_amd64.deb
      systemctl enable refinery.service
      systemctl start refinery.service
    fi
  EOF
  user_data_replace_on_change = true
}
