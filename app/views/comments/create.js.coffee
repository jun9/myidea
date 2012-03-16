 addDiv = $("#add-comment-<%= @idea_id %>") 
 form = addDiv.find("form")
 form.prev().remove()
<% if @comment.errors.any? %> 
 form.before('<%= errors_msg_tag @comment %>')
<% else %>
 addDiv.hide()
 comment = $('<%= escape_javascript( render(:partial => @comment )) %>')
 form[0].reset()
 comment.insertBefore("#after-comments-<%= @idea_id %>")
 $(comment[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $(comment[2]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $('#action-button-<%= @idea_id %>').show()
<% end %>
