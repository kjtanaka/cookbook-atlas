#
# Cookbook Name:: atlas
# Recipe:: _moc
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

directories = [
  node['atlas']['download_dir'], 
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}",
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/build",
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/lib",
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}",
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/lib",
  "#{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/include"
]
directories.each do |dir|
  directory dir do
    owner "root"
    group "root"
    mode "0755"
    action :create
  end
end

bash "create_moc_files" do
  user "root"
  code <<-EOH
  touch #{node['atlas']['download_dir']}/atlas#{node['atlas']['version']}.tar.gz
  touch #{node['atlas']['download_dir']}/atlas-#{node['atlas']['version']}/lib/libatlas.a
  touch #{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/lib/libatlas.a
  touch #{node['atlas']['install_dir']}/atlas-#{node['atlas']['version']}/include/atlas_lapack.h
  EOH
end

