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

include_recipe "build-essential"

node['atlas']['required_packages'].each do |pkg|
    package pkg do
          action :install
            end
end

directory node['atlas']['download_dir'] do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

remote_file "#{node['atlas']['download_dir']}/atlas3.8.3.tar.gz" do
  source node['atlas']['download_url']
  owner "root"
  group "root"
  mode "0644"
  action :create_if_missing
end

bash "extract_tarball" do
  cwd node['atlas']['download_dir']
  user "root"
  code <<-EOH
  tar zxf atlas#{node['atlas']['version']}.tar.gz
  mv ATLAS atlas-#{node['atlas']['version']}
  EOH
  creates "atlas-#{node['atlas']['version']}"
end

directory "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/build" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

bash "install_atlas" do
  cwd "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/build"
  user "root"
  code <<-EOH
  ../configure -Fa alg -fPIC --with-netlib-lapack=#{node['atlas']['liblapack']}
  make
  EOH
  creates "../lib/libatlas.a"
end

directory "#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}" do
  owner "root"
  group "root"
  mode "0755"
  action :create
end

execute "copy_lib" do
  cwd "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}"
  command "rsync -av lib/ #{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/lib"
  creates "#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/lib/libatlas.a"
end

execute "copy_include" do
  cwd "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}"
  command "rsync -av include/ #{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/include"
  creates "#{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/include/atlas_lapack.h"
end
