 form=$('#edit_idea_<%= @idea.id %>')
 form.prev().remove()
<% if @idea.errors.any? %>
 form.before('<%= errors_msg_tag @idea %>')
<% else %>
 idea = $('<%= escape_javascript( render(:partial => "form",:locals => {:idea => @idea})) %>')
 idea.find('.edit-idea-link').click -> showEditForm("#edit-idea-",this)
 $('#edit-idea-<%= @idea.id %>').remove()
 $(idea[0]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $(idea[2]).css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
 $('#idea-<%= @idea.id %>').replaceWith(idea)
<% end %>
