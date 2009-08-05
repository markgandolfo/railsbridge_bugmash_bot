require File.join(File.dirname(__FILE__), 'test_helper')

class TicketTest < Test::Unit::TestCase
  include Lighthouse
  
  def setup
    fake_everything
    @project = Project.find(8994)
    @tickets = @project.tickets
    
  end
  
  context Ticket do
    should "be able to find all tickets" do
      assert_not_nil @tickets
    end
  end
  
end
