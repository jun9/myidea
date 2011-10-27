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

end
