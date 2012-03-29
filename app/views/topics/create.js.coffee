 $('#alert').remove()
<% if @topic.errors.any? %>
 $('#new_topic').before('<%= errors_msg_tag(@topic) %>')
<% else %>
 $('#new_topic')[0].reset()
 $('<%= escape_javascript(render(:partial => @topic)) %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500).prependTo('#topics')
 $('#edit-topic-<%= @topic.id %>').click -> editTopic(this)
<% end %>
