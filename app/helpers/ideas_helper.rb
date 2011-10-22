# encoding: utf-8
module IdeasHelper

  def like_button_tag(login_user,idea)
    if login_user
      if idea.likers.exists?(login_user.id)
        button_tag "踩",:value => idea.id,:type => "button",:class => "vote-toggle vote-no"
      else
        button_tag "顶",:value => idea.id,:type => "button",:class => "vote-toggle vote-yes"
      end
    else
      button_tag "顶",:value => idea.id,:type => "button",:class => "vote-toggle",:title => "请先登录"
    end
  end

end
