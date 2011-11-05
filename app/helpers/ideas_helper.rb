# encoding: utf-8
module IdeasHelper

  def like_button_tag(name,style,login_user,idea)
    options = {:value => idea.id,:type => "button",:class => style}
    if login_user
      if idea.likers.exists?(login_user.id)
        options[:class] = options[:class]+" vote-disabled"
      end
    else
      options[:title] = "请先登录"
    end
      button_tag name,options
  end

  def status_span_tag(idea)
    case idea.status
    when IDEA_STATUS_UNDER_REVIEW
      statusClass = "under-review"
      statusContent = "审核中"
    when IDEA_STATUS_REVIEWED
      statusClass = "reviewed"
      statusContent = "已审核"
    when IDEA_STATUS_IN_THE_WORKS
      statusClass = "in-the-works"
      statusContent = "实施中"
    when IDEA_STATUS_LAUNCHED
      statusClass = "launched"
      statusContent = "已实施"
    end
    if(statusClass) 
      content_tag(:span,statusContent, :class => statusClass,:title => statusContent)
    end
  end

  def checkbox_status_tag(status,statusChecked,options)
    checked = false
    if statusChecked && statusChecked.include?("#{status}") 
      checked = true
    end
    check_box_tag 'status-checkbox',status,checked,options    
  end
end
