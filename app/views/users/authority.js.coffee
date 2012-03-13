 $('#alert').remove()
<% if @user.errors.any? %>
 $('#user-query-form').before('<%= errors_msg_tag(@user) %>')
 <% if @user.admin %>
 $("#admin_radio"+<%= @user.id %>+"_no").attr("checked","checked")
 <% else %>
 $("#admin_radio"+<%= @user.id %>+"_yes").attr("checked","checked")
 <% end %>
<% end %>
