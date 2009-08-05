module Lighthouse
  class Project < Base
    def tickets(options = {})
      Ticket.find(:all, :params => options.update(:project_id => id))
    end

    def messages(options = {})
      Message.find(:all, :params => options.update(:project_id => id))
    end

    def milestones(options = {})
      Milestone.find(:all, :params => options.update(:project_id => id))
    end

    def bins(options = {})
      Bin.find(:all, :params => options.update(:project_id => id))
    end
  
    def changesets(options = {})
      Changeset.find(:all, :params => options.update(:project_id => id))
    end

    def memberships(options = {})
      ProjectMembership.find(:all, :params => options.update(:project_id => id))
    end

    def tags(options = {})
      TagResource.find(:all, :params => options.update(:project_id => id))
    end
  end
end