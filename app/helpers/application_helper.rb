module ApplicationHelper
  def error_msg_tag(msg)
    content_tag :div do
      [content_tag(:span,"",:class=>"ui-icon ui-icon-alert msg"),msg,content_tag(:a,content_tag(:span,'close',:class=>"ui-icon ui-icon-closethick"),:href =>"javascript:closeFlash();",:class => "close")].join.html_safe
    end
  end

  def errors_msg_tag(object)
    if object.errors.any?
        content_tag :div,:class => "ui-state-error ui-corner-all error-msg" do
          object.errors.full_messages.map.with_index{ |msg,index|
            if index == 0
              [error_msg_tag(msg),content_tag(:div,'',:class=>"clear")].join.html_safe
            else
              [content_tag(:div,content_tag(:span,"",:class=>"ui-icon ui-icon-alert msg")+msg),content_tag(:div,'',:class=>"clear")].join.html_safe 
            end
          }.join.html_safe
        end
    end
  end

  def errors_flash_tag(msg)
    if msg
      content_tag :div,error_msg_tag(msg),:class => "ui-state-error ui-corner-all error-msg"
    end
  end
end
