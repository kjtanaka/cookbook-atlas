#
# Cookbook Name:: atlas
# Recipe:: default
# Author:: Koji Tanaka (<kj.tanaka@gmail.com>)
#
# Copyright 2014, FutureGrid, Indiana University
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install required packages
include_recipe "build-essential"
node['atlas']['required_packages'].each do |pkg|
    package pkg do
          action :install
            end
end

# Make sure download directory exists
directory node['atlas']['download_dir'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

# Download Lapack
remote_file "#{node['atlas']['download_dir']}/lapack-#{node['atlas']['lapack_version']}.tgz" do
  source node['atlas']['lapack_download_url']
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

# Download ATLAS
remote_file "#{node['atlas']['download_dir']}/atlas#{node['atlas']['version']}.tar.bz2" do
  source node['atlas']['download_url']
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

# Extract ATLAS tarball
bash "extract_atlas" do
  cwd node['atlas']['download_dir']
  user "root"
  code <<-EOH
  tar jxf atlas#{node['atlas']['version']}.tar.bz2
  mv ATLAS atlas-#{node['atlas']['version']}
  EOH
  creates "atlas-#{node['atlas']['version']}"
end

# Create build directory
directory "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/build" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

if node['atlas']['cpufreq_set']
  execute "set_cpufreq_performance" do
    user "root"
    command "cpufreq-set -g performance"
    not_if { ::File.exists?("#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}")}
  end
end

# Install ATLAS
bash "install_atlas" do
  cwd "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/build"
  user "root"
  code <<-EOH
  ../configure -Fa alg -fPIC --prefix=#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']} --with-netlib-lapack-tarfile=#{node['atlas']['download_dir']}/lapack-#{node['atlas']['lapack_version']}.tgz
  make
  make install
  EOH
  creates "#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}"
end
