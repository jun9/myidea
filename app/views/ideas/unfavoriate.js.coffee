<% unless @idea.errors.any? %>
 $("#favor-link-<%= @idea.id %>").replaceWith('<%= favor_idea_button(@idea) %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
