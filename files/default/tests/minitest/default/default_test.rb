class TestJira < MiniTest::Chef::TestCase

  def test_jira_war_unpacked
    path = "/usr/local/tomcat/jira/webapps/jira"
    assert File.exists? path
    assert File.stat(path).nlink != 2
  end

  def test_jira_jars_created
    assert File.exists? "/usr/local/tomcat/jira/webapps/jira/WEB-INF/lib/xapool-1.3.1.jar"
  end
  
end
 
