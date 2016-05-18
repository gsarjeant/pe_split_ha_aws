class pe_split_ha_aws::instances(
  String $aws_username,
  String $department,
  String $ec2_region,
  String $ec2_availability_zone,
  String $ec2_image_id,
  String $ec2_vpc_subnet_name,
  String $ec2_vpc_security_group_name_name,
  String $ec2_inbound_ssh_ip
){

  # AWS EC2 instance resource defaults
  Ec2_instance {
    ensure            => present,
    instance_type     => "m4.xlarge",
    monitoring        => "false",
    region            => $ec2_region,
    availability_zone => $ec2_availability_zone,
    image_id          => $ec2_image_id,
    key_name          => $aws_username,
    subnet            => $ec2_vpc_subnet_name,
    security_groups   => [ $ec2_security_group_name ],
    tags              => {
      created_by => $aws_username,
      department => "psteam",
      project    => "Split HA Architecture Validation",
    },
  }

  #####################################################
  # EC2 instances
  # We need 11 to really test this thing
  #####################################################
  # Site A - Active
  #####################################################

  # Active MoM
  ec2_instance { 'site_a_mom':
    name   => "$aws_username PE Split HA MoM A",
  }
  # Active Console
  ec2_instance { 'site_a_console':
    name   => "$aws_username PE Split HA Console A",
  }
  # Active PuppetDB
  ec2_instance { 'site_a_puppetdb':
    name   => "$aws_username PE Split HA PuppetDB A",
  }
  # Active Postgres
  ec2_instance { 'site_a_postgres':
    name   => "$aws_username PE Split HA Postgres A",
  }
  # Active Compile
  ec2_instance { 'site_a_compile':
    name   => "$aws_username PE Split HA Compile A",
  }

  #####################################################
  # Site B - Passive
  #####################################################

  # Passive MoM
  ec2_instance { 'site_b_mom':
    name   => "$aws_username PE Split HA MoM B",
  }
  # Passive Console
  ec2_instance { 'site_b_console':
    name   => "$aws_username PE Split HA Console B",
  }
  # Passive PuppetDB
  ec2_instance { 'site_b_puppetdb':
    name   => "$aws_username PE Split HA PuppetDB B",
  }
  # Passive Postgres
  ec2_instance { 'site_b_postgres':
    name   => "$aws_username PE Split HA Postgres B",
  }
  # Passive Compile
  ec2_instance { 'site_b_compile':
    name   => "$aws_username PE Split HA Compile B",
  }

  #####################################################
  # Agent
  #####################################################

  # Puppet Agent
  ec2_instance { 'puppet_agent':
    name   => "$aws_username PE Split HA Puppet Agent",
  }

}
