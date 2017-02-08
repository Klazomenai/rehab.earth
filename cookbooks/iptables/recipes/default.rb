service "firewalld" do
  supports :status => true
  action [:disable, :stop]
end

package "iptables-services"

service "iptables" do
  supports :status => true
  action [:enable, :start]
end
