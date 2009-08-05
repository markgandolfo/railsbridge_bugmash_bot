require File.join(File.dirname(__FILE__), 'test_helper')

class TagTest < Test::Unit::TestCase
  include Lighthouse
  
  def setup
    fake_everything
    @project = Project.find(8994)
    @tags = @project.tags
  end
  
  context Tag do
    should "have some tags" do
      assert_not_nil @tags
    end
    
    should "be able to find tickets based on a tag" do
      tickets = @tags.last.tickets
      assert_equal 1, tickets.size
    end
    
  end
  
end
