# encoding: utf-8
module ApplicationHelper
  def errors_msg_tag(object)
    if object.errors.any?
      content_tag :div,:class => "alert alert-block alert-error" do
        list_items = object.errors.full_messages.map { |msg| content_tag(:li, msg) }
        link_to("×","javascript:;",:class =>"close","data-dismiss"=>"alert")+content_tag(:h4,"错误",:class => "alert-heading")+content_tag(:ul, list_items.join.html_safe)
      end
    end
  end

  def flash_msg_tag(msg,className)
    if msg
      content_tag :div,:class => "alert #{className}" do
        [link_to("×","javascript:;",:class=>"close","data-dismiss"=>"alert"),msg].join.html_safe
      end
    end
  end
end
