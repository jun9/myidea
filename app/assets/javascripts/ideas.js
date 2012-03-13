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

function submitEditUserForm(id,admin,active,$editUserForm,$adminInput,$activeInput){
  var action = $editUserForm.attr("action");
  var i = action.lastIndexOf("/"); 
  var last = action.substring(i);
  var first = action.substring(0,i)
  $editUserForm.attr("action",first.substring(0,first.lastIndexOf("/")+1)+id+last);
  $adminInput.val(admin);
  $activeInput.val(active);
  $editUserForm.submit();
} 

function makeVoteButton(){
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
}

function prepareIdeas(){
  $("#ideas > div:first").addClass("first");
  // Category Select
  $categorySel = $('#category_id');
  $categorySel.change(function(){
    searchIdeas(this.value,$statusButtonSet);
  });
  // Status Button
  $statusButtonSet = $( "#status-button-set" );
  statusRadioButtons = $statusButtonSet.buttonset()
  .children("input");
  var i = 0;
  $(statusRadioButtons[i++]).button({
      text: false,
      icons: {
          primary: "ui-icon-pencil"
      }
  });
  $(statusRadioButtons[i++]).button({
      text: false,
      icons: {
          primary: "ui-icon-document"
      }
  });
  $(statusRadioButtons[i++]).button({
      text: false,
      icons: {
          primary: "ui-icon-gear"
      }
  });
  $(statusRadioButtons[i++]).button({
      text: false,
      icons: {
          primary: "ui-icon-check"
      }
  });
  statusRadioButtons.change(function(){
    searchIdeas($categorySel.val(),$statusButtonSet);
  });
  // Vote Button
  makeVoteButton();
  // AJAX Pagination
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

function preparePreferences(){
  $editPreferenceForm = $("#edit-preference-form");
  $editPreferenceDialog = $('#edit-preference-dialog');
  $tabBox = $('#tab-box').addClass("tab-content");
  // Preference Edit Button
  $tabBox.find('a.preference-edit').button({
    text: false,
    icons: {
      primary: "ui-icon-pencil"
    }
  }).click(function(){
    var $btn = $(this);
    var value = $btn.parent().prev().text();
    var id = $btn.attr("id").substring($btn.attr("id").lastIndexOf("-")+1);
    var action = $editPreferenceForm.attr("action");
    $editPreferenceForm.attr("action",action.substring(0,action.lastIndexOf("/")+1)+id);
    $editPreferenceDialog.find("#value").val(value);
    $editPreferenceDialog.dialog('open');
  });
}

$(function(){
  $('#inbox').tooltip({
    selector: "a[rel=tooltip]"
  });

  $('.comment-form').hide();
  $('.comment-btn').each(function(){
    $(this).click(function(){
      $(this).parent().hide().next().show().find('a.close').click(function(){
        $close = $(this);
        $close.parent().parent().hide().prev().show();
        $close.next()[0].reset();
        $close.parent().prev().remove();
      });
    });
  });
});
