default['atlas']['version'] = "3.10.2"
default['atlas']['download_url'] = "http://downloads.sourceforge.net/project/math-atlas/Stable/#{node['atlas']['version']}/atlas#{node['atlas']['version']}.tar.bz2"
default['atlas']['download_dir'] = "/root/source"
default['atlas']['install_dir'] = "/opt"
default['atlas']['lapack_version'] = "3.5.0"
default['atlas']['lapack_download_url'] = "http://www.netlib.org/lapack/lapack-#{node['atlas']['lapack_version']}.tgz"
default['atlas']['required_packages'] = %w[gcc-gfortran rsync cpufrequtils]

# Environment Modules
default['atlas']['modulefile_dir'] = "/opt/modules-3.2.10/Modules/3.2.10/modulefiles/atlas"
default['atlas']['default_version'] = node['atlas']['version']
