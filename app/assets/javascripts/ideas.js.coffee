root = exports ? this
root.showForm = (type,target) ->
 addBtn = $(target) 
 addBtn.parent().hide()
 $(type+addBtn.data('idea')).show().find('a.close').click ->
  closeX = $(this)
  form = closeX.parent() 
  form.parent().hide()
  form[0].reset()
  form.prev().remove()
  $("#action-button-"+closeX.data('idea')).show()

showMore = (target) ->
 link = $(target)
 more = link.data("more")
 row=link.parent().parent()
 row.prev().remove()
 current = row.next()
 for i in [1..more]
  do ->
   current.show('blind','','fast')
   current=current.next()
 row.remove()

jQuery ($) ->
  $('#inbox').tooltip selector: "a[rel=tooltip]"
  $('.comment-btn').click -> showForm("#add-comment-",this)
  $('.solution-btn').click -> showForm("#add-solution-",this)
  $('.show-more > a').click -> showMore(this)
