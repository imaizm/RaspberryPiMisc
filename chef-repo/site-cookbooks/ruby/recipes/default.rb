#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
RBENV_ROOT = "#{node["user"]["home"]}/.rbenv"

git RBENV_ROOT do
	repository "https://github.com/sstephenson/rbenv.git"
	reference "master"
	action :checkout
	user node["user"]["name"]
	group node["user"]["group"]
end

file "#{node["user"]["home"]}/.bash_profile" do
	owner node["user"]["name"]
	group node["user"]["group"]
	action :create_if_missing
end

bash "setup rbenv" do
	user node["user"]["name"]
	group node["user"]["group"]
	environment "HOME" => node["user"]["home"]
	code <<-EOC
		mkdir #{RBENV_ROOT}/plugins
		echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
		echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
		source ~/.bash_profile
	EOC
	not_if { File.read("#{node["user"]["home"]}/.bash_profile").include?("rbenv") }
end

git "#{RBENV_ROOT}/plugins/ruby-build" do
	repository "https://github.com/sstephenson/ruby-build.git"
	reference "master"
	action :checkout
	user node["user"]["name"]
	group node["user"]["group"]
end

%w(build-essential libreadline-dev libssl-dev).each do |pkg|
	package pkg do
		action :install
	end
end

bash "install ruby" do
	user node["user"]["name"]
	group node["user"]["group"]
	environment "HOME" => node["user"]["home"]
	code <<-EOC
		#{RBENV_ROOT}/bin/rbenv install #{node["version"]["ruby"]}
		#{RBENV_ROOT}/bin/rbenv global #{node["version"]["ruby"]}
	EOC
	creates "#{RBENV_ROOT}/version"
	timeout 6 * 60 * 60
end
