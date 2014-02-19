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

require 'spec_helper'

describe 'ceph::osd' do

  describe 'Debian Family' do

    describe "with custom params" do

      let :facts do
        {
          :operatingsystem => 'Ubuntu',
        }
      end

      let :title do
        '/tmp'
      end

      let :params do
        {
          :authentication_type => 'none',
        }
      end

      it { should contain_exec('ceph-osd-mkfs-/tmp') }

#      it { p subject.resources }

    end
  end
end

# Local Variables:
# compile-command: "cd ../.. ;
#    bundle install ;
#    bundle exec rake spec
# "
# End:
