root = exports ? this
root.showEditForm = (type,target) ->
 editLink = $(target)
 $("#idea-"+editLink.data('idea')).hide()
 $(type+editLink.data('idea')).show().find('a.close').click ->
  closeX = $(this)
  form = closeX.parent()
  form.parent().parent().hide()
  form.prev().remove()
  $("#idea-"+closeX.data('idea')).show()

showForm = (type,target) ->
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
activeIcon = (target) ->
 li = $(target).parent().addClass("active")
 li.siblings().removeClass("active").find("i").removeClass("icon-white")
 li.find("i").addClass("icon-white")

getActiveLinkParam = (id) ->
 url=$(id).children(".active").find("a").attr("href")
 url.substring(url.indexOf("?")+1) if url

fillIdeas = (html) -> $("#ideas-main").html(html)
fillIdea = (html) -> $("#idea-main").html(html)

initStatusTab = ->
 $('#nav-status a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   activeLinkParam = getActiveLinkParam('#nav-owner-ideas')
   settings.url = settings.url+"&"+(activeLinkParam or= getActiveLinkParam('#nav-topic-ideas'))
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initRightNav = ->
 $('#nav-owner-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')
   $('#nav-topic-ideas').children().removeClass("active").find("i").removeClass("icon-white")
   active(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))
 $('#nav-topic-ideas a')
  .bind("ajax:beforeSend",(evt,xhr,settings) ->
   settings.url = settings.url+"&"+getActiveLinkParam('#nav-status')
   $('#nav-owner-ideas').children().removeClass("active")
   activeIcon(this))
  .bind("ajax:success",(evt,data,status,xhr) -> initIdeas(xhr.responseText))

initIdeas = (html) ->
 if html
  fillIdeas(html)
 else
  initStatusTab()
  initRightNav()
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.show-more > a').click -> showMore(this)
 $('.edit-idea-link').click -> showEditForm("#edit-idea-",this)
 $('#ideas-pagination li:not(.disabled,.active) a').attr('data-remote','true').bind('ajax:complete',(evt, xhr, status) -> initIdeas(xhr.responseText))

pickSolution = (target) ->
 checkbox = $(target)
 if checkbox.attr("checked")
  checkbox.parent().parent().parent().parent().addClass("pick").prev().addClass("pick")
 else
  checkbox.parent().parent().parent().parent().removeClass("pick").prev().removeClass("pick")

changeInTheWorkButtonLink = (target) ->
 link = $(target)
 solutionIds = ''
 $('.solution-pick:checked').each ->
  solutionIds += "&solutionIds[]="+this.value
 link.attr('href',link.attr('href')+solutionIds)

initIdea = (html) ->
 fillIdea(html) if html
 $('.comment-btn').click -> showForm("#add-comment-",this)
 $('.solution-btn').click -> showForm("#add-solution-",this)
 $('.edit-idea-link').click -> showEditForm("#edit-idea-",this)
 $('.solution-pick').change -> pickSolution(this)
 $('#in-the-work-buton').click -> changeInTheWorkButtonLink(this)

jQuery ($) ->
 $('#inbox').tooltip selector: "a[rel=tooltip]"
 initIdeas() if $('#ideas-main').length > 0
 initIdea() if $('#idea-main').length > 0
