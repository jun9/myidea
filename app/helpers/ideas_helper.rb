# encoding: utf-8
module IdeasHelper

  def like_button_tag(body,url,action,idea)
    options  = {:remote => true,:class => "vote-toggle"}
    if can? action,idea
      if idea.voters.exists?(session[:login_user].id)
        options[:class] = options[:class]+" vote-disabled"
      end
    else
      options[:title] = "请先登录"
    end
      link_to body,url,options
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

  def comment_entry_tag(comment)
    entryClass = "entry"
    if comment.user.admin
      entryClass = entryClass + " admin"
    end
    content_tag(:div,content_tag(:p,(raw comment.content)),:class => entryClass)
  end

  def handle_idea_tag(idea)
    if can? :handle,idea
      if idea.status
        case idea.status
        when IDEA_STATUS_UNDER_REVIEW
          linkName = "完成审核"
        when IDEA_STATUS_REVIEWED
          linkName = "开始实施"
        when IDEA_STATUS_IN_THE_WORKS
          linkName = "完成实施"
        end
      else
        linkName = "开始审核"
      end
      if linkName
        content_tag(:li,(link_to linkName,handle_idea_path(idea),:confirm => "确定要#{linkName}吗？"),:class => "manage")
      end
    end
  end

  def comment_anchor_tag(current,other,name)
    if current == other
      content_tag(:a,nil,:name => name)
    end
  end
end
