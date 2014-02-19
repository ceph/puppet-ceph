# vim:ft=ruby
source 'https://rubygems.org'

group :development, :test do
  gem 'puppetlabs_spec_helper', :require => false
  gem 'puppet-lint', '~> 0.3.2'
  gem 'rspec-system', :git => 'https://git.gitorious.org/rspec-system/rspec-system.git', :branch => 'master'
  gem 'rspec-system-puppet', '= 2.2.1'
end

if puppetversion = ENV['PUPPET_GEM_VERSION']
  gem 'puppet', puppetversion, :require => false
else
  gem 'puppet', :require => false
end
