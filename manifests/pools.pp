# (C) Copyright 2015 Hewlett Packard Enterprise Development LP 
#
# Author: Shivendra Ashish <shivendra.ashish@hpe.com>
#
# == Class: ceph::pools
#
# Class wrapper for the benefit of scenario_node_terminus
#
# === Parameters:
#
# [*args*] A Ceph pools config hash
#   Mandatory.
#
# [*defaults*] A config hash
#   Optional. Defaults to an empty hash
#
class ceph::pools($args, $defaults = {}) {
  create_resources(ceph::pool, $args, $defaults)
}
