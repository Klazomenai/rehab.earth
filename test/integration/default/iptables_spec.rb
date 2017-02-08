describe service('firewalld') do
    it { should_not be_enabled }
    it { should_not be_running }
end

describe package('iptables-services') do
  it { should be_installed }
end

describe service('iptables') do
    it { should be_enabled }
    it { should be_running }
end
