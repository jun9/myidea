// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
$(function(){
  $('#pub-idea').button({
    icons: {
	  primary: "ui-icon-lightbulb"
	}
  });
  $('#dashboard').button({
    icons: {
	  primary: "ui-icon-wrench"
	}
  });
  $('#searchBtn').button({
    icons: {
	  primary: "ui-icon-search"
	}
  });
  var $tabs = $('#tabs');
  if($('#tabs').length > 0){
    $('.cate_link')
    .bind("ajax:beforeSend", function(evt, xhr , settings){
        var style = $tabs.tabs('option','selected');
        settings.url = settings.url+"&style="+style;
    })
    .bind("ajax:success", function(evt, data, status, xhr){
      showIdeasTab(xhr.responseText);
    });
  }else{
    $('.cate_link').removeAttr('data-remote');
  }
  var $searchform=$('#search-form').submit(function(){
    if($.trim($('#query').val())=='')
      return false;
  });
  if($('#search-tabs').length > 0){
    $searchform.attr('data-remote','true')
    .bind("ajax:complete", function(evt, xhr, status){
      showSearchTab(xhr.responseText);
    });
  }
  
});
function prepareIdeas(){
  $("#ideas > div:first").addClass("first");
  $statusButtonSet = $( "#status-button-set" );
  $statusButtonSet.buttonset()
  .children(":nth-child(2)").button({
      text: false,
      icons: {
          primary: "ui-icon-pencil"
      }
  }).next().next().button({
      text: false,
      icons: {
          primary: "ui-icon-document"
      }
  }).next().next().button({
      text: false,
      icons: {
          primary: "ui-icon-gear",
      }
  }).next().next().button({
      text: false,
      icons: {
          primary: "ui-icon-check",
      }
  });
 
  $('.vote-toggle').each(function(){
    $btn = $(this);
    if($btn.hasClass("vote-disabled")){
      $btn.button({disabled:true});
    }else{
      $btn.button()
      .bind("ajax:beforeSend", function(evt, xhr, settings){
        if(this.title){
          $('#login-dialog').dialog("open");
          return false;
        }
      })
      .bind("ajax:success", function(evt, data, status, xhr){
        idea = $.parseJSON(xhr.responseText);
        $btnThis = $(this);
        $btnThis.parent().children().button({disabled:true});
        $btnThis.parent().next().find("strong").text(idea.points);
      });
    }
  });
  $categorySel = $('#category_id');
  $categorySel.change(function(){
    searchIdeas(this.value,$statusButtonSet);
  });
  $statusButtonSet.children("input").change(function(){
    searchIdeas($categorySel.val(),$statusButtonSet);
  });
  $('.ideas-pagination a').attr('data-remote','true')
  .bind("ajax:success", function(evt, data, status, xhr){
    showIdeasTab(xhr.responseText);
  });
  $('.search-pagination a').attr('data-remote','true')
  .bind("ajax:complete", function(evt, xhr, status){
    showSearchTab(xhr.responseText);
  });
}
function prepareComments(){
  $("#comments > div:first").addClass("first");
  $('.comments-pagination a').attr('data-remote','true')
  .bind('ajax:complete', function(evt, xhr, status){
    $("#comments-box").html(xhr.responseText);
    prepareComments();
  });
}
function prepareDashboard(){
  $editCateForm = $("#edit-cate-form");
  $addCateDialog = $('#add-cate-dialog').dialog({
        width: 400,
        modal:true,
        autoOpen:false,
        buttons:{
          "提交":function(){
             $("#add-cate-form").submit();
          },
          "关闭":function(){
            $(this).dialog("close").children(":first").empty();
          }
        }
  });
   $editCateDialog = $('#edit-cate-dialog').dialog({
        width: 400,
        modal:true,
        autoOpen:false,
        buttons:{
          "提交":function(){
             $editCateForm.submit();
          },
          "关闭":function(){
            $(this).dialog("close").children(":first").empty();
          }
        }
  });
 $tabBox = $('#tab-box').addClass("tab-content");
  $tabBox.find('a.cate-del').button({
      text: false,
      icons: {
          primary: "ui-icon-trash"
      }
  }).bind("ajax:success", function(evt, data, status, xhr){
    $(this).parent().parent().remove();
  }).bind('ajax:error', function(evt, xhr, status, error){
    var errors = $.parseJSON(xhr.responseText);
    alert(errors.base);
  });
  $tabBox.find('button.cate-edit').button({
      text: false,
      icons: {
          primary: "ui-icon-pencil"
      }
  }).click(function(){
      var $btn = $(this);
      var name = $btn.parent().prev().prev().text();
      var id = $btn.val();
      var action = $editCateForm.attr("action");
      $editCateForm.attr("action",action.substring(0,action.lastIndexOf("/")+1)+id);
      $editCateDialog.find("#name").val(name);
      $editCateDialog.dialog('open');
  });
  $tabBox.find('button.cate-add').button({
      icons: {
          primary: "ui-icon-plus"
      }
  }).click(function(){
      $addCateDialog.dialog('open');
  });
}
function showIdeasTab(data){
  $('#tab-box').html(data);
  prepareIdeas(); 
}
function showSearchTab(data){
  $("#search-tabs-box").html(data);
  prepareIdeas();
}
function searchIdeas(cate_id,statusButtonSet){
  var style = $('#tabs').tabs('option','selected')
  var status = [];
  statusButtonSet.children("input:checked").each(function(){
    status.push(this.value);
  });
  $.get('/ideas/tab',{cate_id:cate_id,style:style,status:status},function(data){
    showIdeasTab(data);
  });
}
