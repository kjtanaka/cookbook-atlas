default['atlas']['version'] = "3.8.3"
default['atlas']['download_url'] = "http://downloads.sourceforge.net/project/math-atlas/Stable/#{node['atlas']['version']}/atlas#{node['atlas']['version']}.tar.gz"
default['atlas']['download_dir'] = "/root/source"
default['atlas']['install_dir'] = "/opt"
default['atlas']['liblapack'] = "/opt/lapack-3.5.0/lib/liblapack.a"
default['atlas']['required_packages'] = %w[gcc-gfortran rsync]

# Environment Modules
default['atlas']['modulefile_dir'] = "/opt/modules-3.2.10/Modules/3.2.10/modulefiles/atlas"
default['atlas']['default_version'] = node['atlas']['version']
