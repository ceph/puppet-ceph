#
#  Copyright 2014 Cloudwatt <libre-licensing@cloudwatt.com>
#
#  Author: Loic Dachary <loic@dachary.org>
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
require 'spec_helper_system'

describe 'ceph::osd' do

  releases = [ 'cuttlefish', 'dumpling', 'emperor' ]
  fsid = 'a4807c9a-e76f-4666-a297-6d6cbc922e3a'

#  [].each do |release|
  releases.each do |release|
    describe release do
      it 'should install one OSD no cephx' do
        pp = <<-EOS
          class { 'ceph::repo':
            release => '#{release}',
          }
          ->
          class { 'ceph':
            fsid => '#{fsid}',
            mon_host => $::ipaddress_eth0,
            authentication_type => 'none',
          }
          ->
          ceph::mon { 'a':
            public_addr => $::ipaddress_eth0,
            authentication_type => 'none',
          }
          ->
          ceph::osd { '/dev/sdb':
            authentication_type => 'none',
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree' do |r|
          r.stdout.should =~ /osd.0/
          r.stderr.should be_empty
          r.exit_code.should be_zero
        end

      end

      it 'should uninstall one osd' do
        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should_not be_zero
        end

        pp = <<-EOS
          ceph::osd { '/dev/sdb':
            ensure => absent,
            authentication_type => 'none',
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should be_zero
        end
        shell 'ceph-disk zap /dev/sdb'
      end
    end
  end

#  [].each do |release|
  releases.each do |release|
    describe release do
      it 'should install one osd with cephx' do
        pp = <<-EOS
          class { 'ceph::repo':
            release => '#{release}',
          }
          ->
          class { 'ceph':
            fsid => '#{fsid}',
            mon_host => $::ipaddress_eth0,
          }
          ->
          ceph::mon { 'a':
            public_addr => $::ipaddress_eth0,
            key => 'AQCztJdSyNb0NBAASA2yPZPuwXeIQnDJ9O8gVw==',
          }
          ->
          ceph::osd { '/dev/sdb':
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree' do |r|
          r.stdout.should =~ /osd.0/
          r.stderr.should be_empty
          r.exit_code.should be_zero
        end

      end

      it 'should uninstall one osd' do
        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should_not be_zero
        end

        pp = <<-EOS
          ceph::osd { '/dev/sdb':
            ensure => absent,
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should be_zero
        end

        shell 'ceph-disk zap /dev/sdb'
      end
    end
  end

#  [].each do |release|
  releases.each do |release|
    describe release do
      it 'should install one osd with external journal and cephx' do
        pp = <<-EOS
          class { 'ceph::repo':
            release => '#{release}',
          }
          ->
          class { 'ceph':
            fsid => '#{fsid}',
            mon_host => $::ipaddress_eth0,
          }
          ->
          ceph::mon { 'a':
            public_addr => $::ipaddress_eth0,
            key => 'AQCztJdSyNb0NBAASA2yPZPuwXeIQnDJ9O8gVw==',
          }
          ->
          ceph::osd { '/dev/sdb':
            journal => '/tmp/journal'
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
          r.refresh
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree' do |r|
          r.stdout.should =~ /osd.0/
          r.stderr.should be_empty
          r.exit_code.should be_zero
        end

      end

      it 'should uninstall one osd and external journal' do
        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should_not be_zero
        end

        pp = <<-EOS
          ceph::osd { '/dev/sdb':
            ensure => absent,
          }
        EOS

        puppet_apply(pp) do |r|
          r.exit_code.should_not == 1
        end

        shell 'ceph osd tree | grep DNE' do |r|
          r.exit_code.should be_zero
        end

        shell 'ceph-disk zap /dev/sdb'
      end
    end
  end

end
