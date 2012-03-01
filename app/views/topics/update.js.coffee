 $('#alert').remove()
<% if @topic.errors.any? %>
 $('#new_topic').before('<%= errors_msg_tag(@topic) %>')
<% else %>
 tdBtn = $("#del-topic-<%= @topic.id %>").parent()
 tdCount = tdBtn.prev()
 tdCount.text('<%= @topic.ideas.count %>')
 tdCount.prev().text('<%= escape_javascript @topic.name %>')
 tr = tdCount.parent()
 tr.show().next().remove()
 tr.css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
