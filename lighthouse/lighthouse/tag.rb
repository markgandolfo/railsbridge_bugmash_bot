module Lighthouse
  class Tag < Base
    attr_writer :prefix_options
    attr_accessor :project_id

    def initialize(s, project_id)
      @project_id = project_id
      super(s)
    end

    def prefix_options
      @prefix_options || {}
    end

    def tickets(options = {})
      options[:project_id] ||= @project_id
      Ticket.find(:all, :params => options.merge(prefix_options).update(:q => %{tagged:"#{self.name}"}))
    end
  end
end