service 'postfix' do
  supports :status => true
  action [:stop, :disable]
end
