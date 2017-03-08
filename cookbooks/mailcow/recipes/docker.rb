docker_installation 'default' do
  action :create
end

docker_installation_package 'default' do
  action :create
end

docker_service 'default' do
  action [:create, :start]
end
