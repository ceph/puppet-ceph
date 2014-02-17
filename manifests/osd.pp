#
#   Copyright (C) 2014 Cloudwatt <libre.licensing@cloudwatt.com>
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#
# Author: Loic Dachary <loic@dachary.org>
#

define ceph::osd (
  $ensure = present,
  $journal = undef,
  $cluster = undef,
  $authentication_type = 'cephx',
  ) {

    $data = $name
    
    if $cluster {
      $cluster_option = "--cluster ${cluster}"
    }

    if $ensure == present {
      $ceph_mkfs = "ceph-osd-mkfs-${name}"

      # ceph-disk: prepare should be idempotent http://tracker.ceph.com/issues/7475
      exec { $ceph_mkfs:
        command   => "/bin/true # comment to satisfy puppet syntax requirements
set -ex
if ! ceph-disk list | grep ' *${data}.*ceph data' ; then
  ceph-disk prepare ${cluster_option} \
     $data \
     $journal
fi
",
        logoutput => true,
      }

    } else {

      # ceph-disk: support osd removal http://tracker.ceph.com/issues/7454
      exec { "remove-osd-${name}":
        command   => "/bin/true  # comment to satisfy puppet syntax requirements
set -ex
if [ -z \"\$id\" ] ; then
  id=\$(ceph-disk list | grep ' *${data}.*ceph data' | sed -e 's/.*osd.\\([0-9][0-9]*\\).*/\\1/')
fi
if [ -z \"\$id\" ] ; then
  id=\$(ceph-disk list | grep ' *${data}.*mounted on' | sed -e 's/.*osd.\\([0-9][0-9]*\\)\$/\\1/')
fi
if [ \"\$id\" ] ; then
  stop ceph-osd id=\$id || true
  ceph ${cluster_option} osd rm \$id
  ceph auth del osd.\$id
  umount /var/lib/ceph/osd/ceph-\$id || true
fi
",
        logoutput => true,
      }
    }
    
}
