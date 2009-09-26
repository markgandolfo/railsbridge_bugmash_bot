module Lighthouse
  class Ticket < Base
    attr_writer :tags
    site_format << '/projects/:project_id'

    def id
      attributes['number'] ||= nil
      number
    end

    def tags
      attributes['tag'] ||= nil
      @tags ||= tag.split(" ")
    end

    def body
      attributes['body'] ||= ''
    end

    def body=(value)
      attributes['body'] = value
    end

    def body_html
      attributes['body_html'] ||= ''
    end

    def body_html=(value)
      attributes['body_html'] = value
    end

    def save_with_tags
      self.tag = @tags.collect do |tag|
        tag.include?(' ') ? tag.inspect : tag
      end.join(" ") if @tags.is_a?(Array)
      @tags = nil ; save_without_tags
    end
  
    alias_method_chain :save, :tags

    private
      # taken from Lighthouse Tag code
      def parse_with_spaces(list)
        tags = []

        # first, pull out the quoted tags
        list.gsub!(/\"(.*?)\"\s*/ ) { tags << $1; "" }
      
        # then, get whatever's left
        tags.concat list.split(/\s/)

        cleanup_tags(tags)
      end
  
      def cleanup_tags(tags)
        returning tags do |tag|
          tag.collect! do |t|
            unless tag.blank?
              t = Tag.new(t,prefix_options[:project_id])
              t.downcase!
              t.gsub! /(^')|('$)/, ''
              t.gsub! /[^a-z0-9 \-_@\!']/, ''
              t.strip!
              t.prefix_options = prefix_options
              t
            end
          end
          tag.compact!
          tag.uniq!
        end
      end
  end
end