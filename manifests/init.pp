# Class: pe_split_ha_aws
# ===========================
#
# Full description of class pe_split_ha_aws here.
#
# Parameters
# ----------
#
# Document parameters here.
#
# * `sample parameter`
# Explanation of what this parameter affects and what it defaults to.
# e.g. "Specify one or more upstream ntp servers as an array."
#
# Variables
# ----------
#
# Here you should define a list of variables that this module would require.
#
# * `sample variable`
#  Explanation of how this variable affects the function of this class and if
#  it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#  External Node Classifier as a comma separated list of hostnames." (Note,
#  global variables should be avoided in favor of class parameters as
#  of Puppet 2.6.)
#
# Examples
# --------
#
# @example
#    class { 'pe_split_ha_aws':
#      servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#    }
#
# Authors
# -------
#
# Greg Sarjeant <gsarjeant@puppet.com>
#
# Copyright
# ---------
#
# Copyright 2016 Greg Sarjeant, unless otherwise noted.
#
class pe_split_ha_aws (
  String $aws_username,
  String $department,
  String $ec2_region,
  String $ec2_availability_zone,
  String $ec2_image_id,
  String $ec2_vpc_cidr_block,
  String $ec2_inbound_ssh_ip
){

  # Define the names of the various resources
  $ec2_vpc_name                  = "${aws_username} HA VPC"
  $ec2_vpc_subnet_name           = "${aws_username} HA Subnet"
  $ec2_security_group_name       = "${aws_username} HA SG"
  $ec2_vpc_route_table_name      = "${aws_username} HA Route Table"
  $ec2_vpc_internet_gateway_name = "${aws_username} HA Internet Gateway"

  # Create and configure a VPC for use with the HA testing environment.

  # AWS EC2 VPC
  ec2_vpc { $ec2_vpc_name:
    name       => $ec2_vpc_name,
    region     => $ec2_region,
    cidr_block => $ec2_vpc_cidr_block,
    tags       => {
      created_by => $aws_username,
      department => $department
    },
  }

  # AWS EC2 VPC Security Group
  # Only allow ssh from a single IP
  ec2_securitygroup { $ec2_security_group_name:
    ensure      => present,
    region      => $ec2_region,
    description => "Define inbound SSH for $aws_username HA testing environment",
    vpc         => $ec2_vpc_name,
    ingress     => [
      {
        protocol => 'tcp',
        port     => 22,
        cidr     => "${ec2_inbound_ssh_ip}/32",
      }
    ],
    tags        => {
      created_by => $aws_username,
      department => $department
    },
    require     => [
      Ec2_vpc[ $ec2_vpc_name ],
    ],
  }

  # AWS EC2 VPC Internet Gateway
  ec2_vpc_internet_gateway { $ec2_vpc_internet_gateway_name:
    name   => $ec2_vpc_internet_gateway_name,
    ensure => present,
    region => $ec2_region,
    vpc    => $ec2_vpc_name,
    tags   => {
      created_by => $aws_username,
      department => $department
    },
    require => [
      Ec2_vpc[ $ec2_vpc_name ],
    ],
  }

  # AWS EC2 Route table
  ec2_vpc_routetable { $ec2_vpc_route_table_name:
    name    => $ec2_vpc_routetable_name,
    vpc     => $ec2_vpc_name,
    region  => $ec2_region,
    routes  => [
      {
        destination_cidr_block => $ec2_vpc_cidr_block,
        gateway                => 'local'
      },
      {
        destination_cidr_block => '0.0.0.0/0',
        gateway                => $ec2_vpc_internet_gateway_name
      }
    ],
    tags    => {
      created_by => $aws_username,
      department => $department
    },
    require => [
      Ec2_vpc[ $ec2_vpc_name ],
      Ec2_vpc_internet_gateway[ $ec2_vpc_internet_gateway_name ]
    ],
  }

  # AWS EC2 VPC Subnet
  ec2_vpc_subnet{ $ec2_vpc_subnet_name:
    name                    => $ec2_vpc_subnet_name,
    vpc                     => $ec2_vpc_name,
    region                  => $ec2_region,
    cidr_block              => $ec2_vpc_cidr_block,
    availability_zone       => $ec2_availability_zone,
    map_public_ip_on_launch => true,
    route_table             => $ec2_vpc_route_table_name,
    tags                    => {
      created_by => $aws_username,
      department => $department
    },
    require                 => [
      Ec2_vpc_routetable[ $ec2_vpc_route_table_name ]
    ],
  }

  # Create the instances once all the supporting VPC infrastructure is built
  class{ '::pe_split_ha_aws::instances':
   aws_username                => $aws_username,
   department                  => $department,
   ec2_region                  => $ec2_region,
   ec2_availability_zone       => $ec2_availability_zone,
   ec2_image_id                => $ec2_image_id,
   ec2_vpc_subnet_name         => $ec2_vpc_subnet_name,
   ec2_security_group_name     => $ec2_security_group_name,
   ec2_inbound_ssh_ip          => $ec2_inbound_ssh_ip,
   require                     => [
     Ec2_vpc_subnet[ $ec2_vpc_subnet_name ],
   ],
  }
}
