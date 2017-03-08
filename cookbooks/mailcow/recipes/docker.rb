docker_installation 'default' do
  action :create
end

docker_service 'default' do
  action [:create, :start]
end
