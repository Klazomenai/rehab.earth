include_recipe 'firewall::default'

firewall 'default' do
  action :save
end
