require File.join(File.dirname(__FILE__), 'test_helper')

class ProjectTest < Test::Unit::TestCase
  include Lighthouse
  
  def setup
    fake_everything
    @projects = Project.find(:all)
  end
  
  context Project do
    should "be able to find them all" do
      assert_not_nil @projects
      assert_equal 3, @projects.size
    end
    
    should "be able to find a project" do
      assert_not_nil Project.find(8994)
    end
    
    should "be able to start creating a new project" do
      assert_not_nil Project.new
    end
    
    
  end
  
end
