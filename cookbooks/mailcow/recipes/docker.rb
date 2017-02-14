docker_installation 'default' do
  action :create
end

docker_installation_package 'default' do
  action :create
  version '1.13.0'
  package_version "1.13.1-1.el7.centos"
end

docker_service 'default' do
  action [:create, :start]
end
