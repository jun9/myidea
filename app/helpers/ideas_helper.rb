module IdeasHelper

  def like_button_tag(body,url,action,idea)
    options  = {:remote => true,:class => "vote-toggle"}
    if can? action,idea
      if idea.voters.exists?(session[:login_user].id)
        options[:class] = options[:class]+" vote-disabled"
      end
    else
      options[:title] = I18n.t('app.notice.user.login')
    end
      link_to body,url,options
  end

  def status_span_tag(idea)
    content_tag :span,I18n.t("app.idea.status.#{idea.status}"),:class => "plain bold"
  end

  def fail_span_tag(idea)
    if idea.fail
      content_tag :span,I18n.t("app.idea.fail.#{idea.fail}"), :class =>"plain bold"
    end
  end


  def handle_idea_button(idea,idea_page)
    if idea_page && (can? :handle,idea) && idea.status != IDEA_STATUS_LAUNCHED
      case idea.status
      when IDEA_STATUS_UNDER_REVIEW
        menu_fail_items = [IDEA_FAIL_REPEATED,IDEA_FAIL_LAUNCHED,IDEA_FAIL_INVALID].map{|fail| content_tag(:li,link_to(I18n.t("app.idea.fail.#{fail}"),handle_idea_path(idea,:status => IDEA_STATUS_REVIEWED_FAIL,:fail => fail ),:class => "handle-button",:method => :put ,:remote => true))}
        menu = content_tag :ul,:class=>"dropdown-menu" do
         content_tag(:li,link_to(I18n.t("app.idea.success"),handle_idea_path(idea,:status => IDEA_STATUS_REVIEWED_SUCCESS),:class => "handle-button",:method => :put ,:remote => true))+content_tag(:li,'',:class=>"divider")+menu_fail_items.join.html_safe 
        end
        content_tag :div,:class =>"btn-group" do
          link_to((I18n.t("app.idea.handle.#{idea.status}")+" ").html_safe+content_tag(:span,"",:class=>"caret"),"javascript:;",:class => "handle-button btn btn-primary btn-large dropdown-toggle","data-toggle"=>"dropdown")+menu
        end 
      when IDEA_STATUS_REVIEWED_FAIL
        content_tag(:div,link_to(I18n.t("app.idea.handle.#{idea.status}"),handle_idea_path(idea,:status => IDEA_STATUS_UNDER_REVIEW),:class => "handle-button btn btn-primary btn-large",:method => :put ,:remote => true),:class =>"btn-group")
      when IDEA_STATUS_REVIEWED_SUCCESS
        content_tag(:div,link_to(I18n.t("app.idea.handle.#{idea.status}"),handle_idea_path(idea,:status => IDEA_STATUS_IN_THE_WORKS),:class => "btn btn-primary btn-large",:id=>"in-the-work-buton",:class => "btn btn-primary btn-large",:method => :put ,:remote => true),:class =>"btn-group")
      when IDEA_STATUS_IN_THE_WORKS 
        content_tag(:div,link_to(I18n.t("app.idea.handle.#{idea.status}"),handle_idea_path(idea,:status => IDEA_STATUS_LAUNCHED),:class => "handle-button btn btn-primary btn-large",:method => :put ,:remote => true),:class =>"btn-group")
      end
    end
  end

  def unfavor_idea_button(idea)
	link_to I18n.t("app.idea.unfavoriate"),unfavoriate_idea_path(idea),:remote => true,:id => "favor-link-#{idea.id}",:class=>"btn btn-danger"
  end

  def favor_idea_button(idea)
	link_to I18n.t("app.idea.favoriate"),favoriate_idea_path(idea),:remote => true,:id => "favor-link-#{idea.id}",:class=>"btn btn-success"
  end

  def favor_unfavor_button(idea)
    if can? :favoriate,idea
      content_tag :div,idea.favorers.exists?(current_user.id)?unfavor_idea_button(idea):favor_idea_button(idea),:class=>"btn-group"
    end
  end

end
