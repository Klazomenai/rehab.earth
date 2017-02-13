include_recipe 'docker::default'

docker_service 'default' do
  action [:create, :start]
end
