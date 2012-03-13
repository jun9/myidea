root = exports ? this
root.editTopic = (target) ->
  editBtn = $(target)
  topicId = editBtn.data('topic')
  editForm = $('#edit-form').clone().show()
  editForm.attr
   action:'/topics/'+topicId
   id:'#edit-form-'+topicId
  input = editForm.children("input")
  $(input[0]).val(editBtn.parent().prev().prev().text())
  $(input[2]).click -> 
   tr = $(this).parent().parent().parent()
   tr.prev().show()
   tr.remove()
  $('<tr></tr>').append($('<td colspan="3"></td>').append(editForm)).insertAfter(editBtn.parent().parent().hide())

active = (target) -> 
  li = $(target).parent().addClass("active")
  li.siblings().removeClass("active").find("i").removeClass("icon-white")
  li.find("i").addClass("icon-white")

fill = (html) -> $("#admin-main").html(html)

authorityUserForm = (id,admin) ->
  $("#admin").val(admin)
  $('#authority-user-form').attr("action","/users/"+id+"/authority").submit()

initNavUser = (html) ->
  fill(html)
  $('.pagination li:not(.disabled,.active) a').attr('data-remote','true').bind('ajax:complete',(evt, xhr, status) -> initNavUser(xhr.responseText))
  $('#user-query-form').bind('ajax:complete',(evt, xhr, status) -> initNavUser(xhr.responseText))
  $('.admin_radio_yes').change -> authorityUserForm(this.value,true)
  $('.admin_radio_no').change -> authorityUserForm(this.value,false)

jQuery ($) ->
 $('#nav-home')
  .bind("ajax:beforeSend",(evt,xhr,settings) -> active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> fill(xhr.responseText))
 $('#nav-topic')
  .bind("ajax:beforeSend",(evt,xhr,settings) -> active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> 
   fill(xhr.responseText)
   $('button.edit-topic').click -> editTopic(this))
 $('#nav-user')
  .bind("ajax:beforeSend",(evt,xhr,settings) -> active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initNavUser(xhr.responseText))
