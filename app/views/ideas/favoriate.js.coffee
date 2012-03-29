<% unless @idea.errors.any? %>
  $("#favor-link-<%= @idea.id %>").replaceWith('<%= unfavor_idea_button(@idea) %>').css("backgroundColor","#57A957").animate({backgroundColor:"#fff"},1500)
<% end %>
