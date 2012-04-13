#
# Cookbook Name::       jira
# Description::         installs jira
# Recipe::              default
# Author::              Bryan W. Berry
#
# Copyright 2012, Bryan W. Berry
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "ark"
include_recipe "tomcat::base"
include_recipe "maven"

jira_user = node['jira']['user']
jira_tarball = node['jira']['war_url'].split('/')[-1]

# get passwd
bag, item = node['jira']['passwd_data_bag'].split('/')
password = Chef::EncryptedDataBagItem.load(bag, item)['passwd']

jdbc_url = "jdbc:#{node['jira']['jdbc']['type']}://" +
  "#{node['jira']['jdbc']['server']}:" +
  "#{node['jira']['jdbc']['port']}/" +
  "#{node['jira']['jdbc']['schema']}?" +
  node['jira']['jdbc']['params'].join('&amp;')
  
t = tomcat "jira" do
  user jira_user
  action :install
  jvm_opts node['jira']['jvm_opts']
  env  ["JIRA_HOME=/home/jira"]
end

# get mysql connector
maven "mysql-connector-java" do
  groupId "mysql"
  version "5.1.18"
  owner jira_user
  dest  "#{t.base}/lib"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{jira_tarball}" do
  source node['jira']['war_url']
  checksum node['jira']['war_checksum']
  owner jira_user
end

# install jira_war
ruby_block "move jira war into place" do
  block do
    require 'tmpdir'
    require 'fileutils'
    tmpdir = ::Dir.mktmpdir
    tar_xvzf = Chef::ShellOut.new("tar xvzf #{Chef::Config[:file_cache_path]}/#{jira_tarball} -C #{tmpdir}")
    tar_xvzf.run_command
    webapp_dir = ::Dir.glob("#{tmpdir}/atlassian-jira-*/webapp")[0]
    FileUtils.rm_rf "#{t.base}/webapps/jira"
    FileUtils.mv webapp_dir, "#{t.base}/webapps/jira"
    FileUtils.chown_R jira_user, jira_user, "#{t.base}/webapps/jira"
    FileUtils.rm_rf tmpdir
  end
  not_if { ::File.exists?("#{t.base}/webapps/jira") && File.stat("#{t.base}/webapps/jira").nlink > 2 }
end

# GET ALL THE PLUGINS
remote_file "balsamiq" do
  source node['jira']['balsamiq_url']
  checksum node['jira']['balsamiq_checksum']
  path "#{t.base}/webapps/jira/WEB-INF/lib/balsamiq.jar"
   mode 0755
   owner jira_user
 end


%w{ bonfire bamboo calendar importers }.each do |plugin|
  remote_file plugin do
    source node['jira']["#{plugin}_url"]
    path "/home/jira/plugins/installed-plugins/#{plugin}.jar"
    checksum node['jira']["#{plugin}_checksum"]
    mode 0755
    owner jira_user
  end
end


ark_dump "additional_jars" do
  url node['jira']['jars_url']
  path  "#{t.base}/webapps/jira/WEB-INF/lib"
  owner jira_user
  creates "commons-logging-1.1.1.jar"
  checksum node['jira']['jars_checksum']
end

template "jira properties" do
  path "#{t.base}/webapps/jira/WEB-INF/classes/jira-application.properties"
  source "jira-application.properties.erb"
  owner jira_user
end

template "seraph-config" do
  path "#{t.base}/webapps/jira/WEB-INF/classes/seraph-config.xml"
  source "seraph-config.xml.erb"
  owner jira_user
end

# TODO template entityengine.xml


directory "create context subdirectories" do
  path "#{t.base}/conf/Catalina/localhost"
  recursive true
  owner jira_user
end
  
template "jdbc configuration" do
  path "#{t.base}/conf/Catalina/localhost/jira.xml"
  source "jira.xml.erb"
  owner jira_user
  variables(
            :jdbc_url => jdbc_url,
            :password => password
             )
end

# # start jira if not running
# # and make it subscribe to the preceding files
ruby_block "start jira" do
  block do
    t.run_action(:start)
  end
end
