#
# Cookbook Name::       jira
# Description::         installs jira
# Attributes::          default
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

default['jira']['user'] = "jira"
default['jira']['jvm_opts'] = [
                               "-Dorg.apache.jasper.runtime.BodyContentImpl.LIMIT_BUFFER=true",
                               "-Dmail.mime.decodeparameters=true",
                               "-Xms128m", "-Xmx512m", "-XX:MaxPermSize=256m"
                              ]

default['jira']['passwd_data_bag'] = 'secret/jira_passwd'
default['jira']['war_url'] = "http://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-enterprise-4.2.4-b591.tar.gz"
default['jira']['war_checksum'] ="412a2f28caae74531d18180188e7a43498705c0225ca7a4ab5a0d4b4851a4b97"
default['jira']['jars_url'] = "http://www.atlassian.com/software/jira/downloads/binary/jira-jars-tomcat-distribution-5.0-rc2-tomcat-6x.zip"
default['jira']['jars_checksum'] = "54464f3ffb0f255a0e1101f1b1d5611dba7fe323016be5db37ce7a9aef55da82"
default['jira']['balsamiq_url'] = 'http://builds.balsamiq.com/b/2.1/mockups-jira-4x/mockupsJIRA4x-2.1.13.jar'
default['jira']['balsamiq_checksum'] = "46f368c82069a400eb2bdaaaa24e1480fa816cda47a6534a398f9c5ac4c606da"
default['jira']['bonfire_url'] = 'https://plugins.atlassian.com/download/plugins/com.atlassian.bonfire.plugin/version/9'
default['jira']['bonfire_checksum'] ='7b57c6d1565d1149a9dd9bf5d68e57cd117bbf897866ac513ca909e1733bedf8' 
default['jira']['fisheye_url'] = 'https://plugins.atlassian.com/download/plugins/com.atlassian.jirafisheyeplugin/version/100'
default['jira']['fisheye_checksum'] = '450c5a5403f048779e870792adcfc47e87bd57243663e36609f8bf8e89f5e625'
default['jira']['bamboo_url'] = 'https://plugins.atlassian.com/download/plugins/com.atlassian.jira.plugin.ext.bamboo/version/413'
default['jira']['bamboo_checksum'] = '02e5139295fdf6cda165c376df879231339fd3140f03dbd8e3d1a81e3cb22e17'

default['jira']['calendar_url'] = 'https://plugins.atlassian.com/download/plugins/com.atlassian.jira.ext.calendar/version/1143'
default['jira']['calendar_checksum'] = 'ff6e2d8482b9245fc1d2c08bc657dbe5bc8312b4524360d038b65bee9302ea1e'
default['jira']['importers_url'] = 'https://plugins.atlassian.com/download/plugins/com.atlassian.jira.plugins.jira-importers-plugin/version/13'
default['jira']['importers_checksum'] = '35f75aff97121c0e5dbe91e3ebc47ac9047f1e488b913b09a95a13ff71ca3a7c'

default['jira']['auth']['casServerLoginUrl'] = 'https://cas.example.org/login'
default['jira']['auth']['serverName'] = 'http://jira.example.org'
default['jira']['auth']['casServerUrlPrefix'] = 'https://caf.example.org'

default['jira']['jdbc']['username'] = "jira"
default['jira']['jdbc']['type'] = "mysql"
default['jira']['jdbc']['driver'] = "com.mysql.jdbc.Driver"
default['jira']['jdbc']['server'] = "db.example.com"
default['jira']['jdbc']['port'] = "3330"
default['jira']['jdbc']['schema'] = "jira"
default['jira']['jdbc']['params'] = [ "useUnicode=true", "characterEncoding=UTF8", "sessionVariables=storage_engine=InnoDB" ]

# TODO
# add cas-client-core-3.2.1.jar and
# cas-client-integration-atlassian-3.2.1.jar
