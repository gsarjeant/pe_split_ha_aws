# pe_split_ha_aws

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with pe_split_ha_aws](#setup)
    * [What pe_split_ha_aws affects](#what-pe_split_ha_aws-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with pe_split_ha_aws](#beginning-with-pe_split_ha_aws)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module builds the infrastructure needed to provision a split, two-site
highly-available (HA) implementation of Puppet Enterprise (PE) in Amazon EC2. 

### What pe_split_ha_aws affects

The module will create the following entities in your AWS infrastructure:

* One (1) Virtual Private Cloud (VPC)
* One (1) Internet Gateway
* One (1) Subnet
* One (1) Route Table
* One (1) Security Group
* Eleven (11) VM Instances
    * Five (5) active instances
        * Master-of-Masters (MoM)
        * PE Console
        * PuppetDB
        * Postgresql
        * Catalog Compilation Master
    * Five (5) passive instances
        * Master-of-Masters (MoM)
        * PE Console
        * PuppetDB
        * Postgresql
        * Catalog Compilation Master
    * One (1) Agent system

## Setup

### Setup Requirements **OPTIONAL**

The pe\_split\_ha\_aws module requires the [puppetlabs/aws](https://github.com/puppetlabs/puppetlabs-aws)
to be installed on your puppet master. 

The pe\_split\_ha\_aws module requires the prerequisites for the [puppetlabs/aws](https://github.com/puppetlabs/puppetlabs-aws)
module. These must be configured on the agent node against which this module will be applied. These
prerequisites will ensure that the agent node can invoke AWS commands using your access credentials.

You can manage these prerequisites with the [gsarjeant/aws_module_prereqs](https://github.com/gsarjeant/aws_module_prereqs)
module. Please see that module's documentation for instructions if you prefer to manage
these resources manually.

### Beginning with pe_split_ha_aws


## Usage

This section is where you describe how to customize, configure, and do the
fancy stuff with your module here. It's especially helpful if you include usage
examples and code samples for doing things with your module.

## Reference

Here, include a complete list of your module's classes, types, providers,
facts, along with the parameters for each. Users refer to this section (thus
the name "Reference") to find specific details; most users don't read it per
se.

## Limitations

This is where you list OS compatibility, version compatibility, etc. If there
are Known Issues, you might want to include them under their own heading here.

## Development

Since your module is awesome, other users will want to play with it. Let them
know what the ground rules for contributing are.

## Release Notes/Contributors/Etc. **Optional**

If you aren't using changelog, put your release notes here (though you should
consider using changelog). You can also add any additional sections you feel
are necessary or important to include here. Please use the `## ` header.
