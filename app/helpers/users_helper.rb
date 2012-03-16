module UsersHelper
  def admin_radio_tag(user)
    if user.owner
     t('activerecord.attributes.user.owner') 
    else
      label_tag("",:class => "radio inline") do
        radio_button_tag("admin_radio#{user.id}",user.id,user.admin,:id=>"admin_radio#{user.id}_yes",:class => "admin_radio_yes")+t('myidea.user.admin.radio_yes') 
      end+label_tag("",:class => "radio inline") do
radio_button_tag("admin_radio#{user.id}",user.id,!user.admin,:id=>"admin_radio#{user.id}_no",:class => "admin_radio_no")+t('myidea.user.admin.radio_no') 
      end
    end
  end

  def admin_label_tag(user)
    if user.admin
     content_tag(:span,t('activerecord.attributes.user.admin'),:class =>"label label-important")
    end
  end

  def role_tag(user)
    if @user.owner
      t('activerecord.attributes.user.owner')
    elsif @user.admin
      t('activerecord.attributes.user.admin')
    else
      t('activerecord.attributes.user.normal')
    end
  end
end
