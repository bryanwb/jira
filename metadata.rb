maintainer       "Bryan W. Berry"
maintainer_email "bryan.berry@gmail.com"
license          "Apache 2.0"
description      "Installs/Configures jira"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ java ark tomcat }.each do |cb|
  depends cb
end

%w{ debian ubuntu centos redhat fedora }.each do |os|
  supports os
end

recipe "jira::default", "Installs and configures jira"
