# encoding: utf-8
module UsersHelper
  def admin_radio_tag(user)
    content_tag(:div,(radio_button_tag("admin_radio#{user.id}",user.id,user.admin,:id=>"admin_radio#{user.id}_yes")+label_tag("admin_radio#{user.id}_yes",t('myidea.user.admin.radio_yes'))+radio_button_tag("admin_radio#{user.id}",user.id,!user.admin,:id=>"admin_radio#{user.id}_no")+label_tag("admin_radio#{user.id}_no",t('myidea.user.admin.radio_no'))),:class => 'admin-radio')
  end
  
  def active_radio_tag(user)
    content_tag(:div,(radio_button_tag("active_radio#{user.id}",user.id,user.active,:id=>"active_radio#{user.id}_yes")+label_tag("active_radio#{user.id}_yes",t('myidea.user.active.radio_yes'))+radio_button_tag("active_radio#{user.id}",user.id,!user.active,:id=>"active_radio#{user.id}_no")+label_tag("active_radio#{user.id}_no",t('myidea.user.active.radio_no'))),:class => 'active-radio')
  end
end
