# config/initializers/will_paginate.rb

module WillPaginate
  module ActionView
    def will_paginate(collection = nil, options = {})
      options[:renderer] ||= BootstrapLinkRenderer
      super.try :html_safe
    end

    class BootstrapLinkRenderer < LinkRenderer
      protected
      
      def html_container(html)
        tag :div, tag(:ul, html), container_attributes
      end

      def page_number(page)
        if page == current_page
          tag :li, link(page, 'javascript:;', :rel => rel_value(page)), :class => 'active'
        else
          tag :li, link(page, page, :rel => rel_value(page))
        end
      end

      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || 'javascript:;'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end
  end
end
