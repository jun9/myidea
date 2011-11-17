module ApplicationHelper
  def errors_msg_tag(object)
    if object.errors.any?
        content_tag :div,:class => "ui-state-error ui-corner-all error-msg" do
          object.errors.full_messages.map{ |msg|
            content_tag(:div,content_tag(:span,"",:class=>"ui-icon ui-icon-alert msg")+msg)
          }.join.html_safe
        end
    end
  end

  def errors_flash_tag(msg)
    if msg
      content_tag :div,:class => "ui-state-error ui-corner-all error-msg" do
        content_tag(:div,content_tag(:span,"",:class=>"ui-icon ui-icon-alert msg")+msg)
      end
    end
  end
end
