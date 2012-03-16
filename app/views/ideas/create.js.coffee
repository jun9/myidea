  $('#alert').remove()
<% if @idea.errors.any? %>
  $('#modal-body-add-idea').prepend('<%= errors_msg_tag(@idea) %>')
<% else %>
  location.href = '<%= idea_url(@idea)%>'
<% end %>
