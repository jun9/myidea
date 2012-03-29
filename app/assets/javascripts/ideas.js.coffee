root = exports ? this
root.showForm = (type,target) ->
 addBtn = $(target) 
 addBtn.parent().parent().hide()
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

active = (target) -> $(target).parent().addClass("active").siblings().removeClass("active")

fillIdeas = (html) -> $("#ideas-main").html(html)
fillApp = (html) -> $("#app-main").html(html)

initIdeas = (html) ->
 fillIdeas(html) if html
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.show-more > a').click -> showMore(this)

pickSolution = (target) ->
 checkbox = $(target)
 if checkbox.attr("checked")
  checkbox.parent().parent().parent().parent().addClass("pick").prev().addClass("pick")
 else
  checkbox.parent().parent().parent().parent().removeClass("pick").prev().removeClass("pick")

changeInTheWorkButtonLink = (settings) ->
 solutionIds = ''
 $('.solution-pick:checked').each ->
  solutionIds += "&solutionIds[]="+this.value
 settings.url = settings.url+solutionIds

initIdea = (html) ->
 fillApp(html) if html
 $('.solution-pick').change -> pickSolution(this)
 $('.handle-button').bind("ajax:success",(evt,data,status,xhr) -> initIdea(xhr.responseText))
 $('#in-the-work-buton')
  .bind("ajax:beforeSend",(evt,xhr,settings) -> changeInTheWorkButtonLink(settings))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdea(xhr.responseText))

jQuery ($) ->
 initIdeas()
 initIdea()
 $('#inbox').tooltip selector: "a[rel=tooltip]"
 $('#nav-status a')
  .bind("ajax:beforeSend",(evt,xhr,settings) -> active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))
