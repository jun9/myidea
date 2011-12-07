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

function prepareCategories(){
  $addCateForm = $("#add-cate-form");
  $addCateForm.find("input").keydown(function(event){
    if(event.keyCode==13) {
      $addCateForm.submit();
      return false;
    }
  });
  $addCateDialog = $('#add-cate-dialog').dialog({
    width: 400,
    modal:true,
    autoOpen:false,
    buttons:{
      "提交":function(){
        $addCateForm.submit();
      },
      "关闭":function(){
        $(this).dialog("close").children(":first").empty();
      }
    }
  });
  $editCateForm = $("#edit-cate-form");
  $editCateForm.find("input").keydown(function(event){
    if(event.keyCode==13) {
      $editCateForm.submit();
      return false;
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
  // Category Delete Button
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
  // Category Edit Button
  $tabBox.find('a.cate-edit').button({
    text: false,
    icons: {
      primary: "ui-icon-pencil"
    }
  }).click(function(){
    var $btn = $(this);
    var name = $btn.parent().prev().prev().text();
    var id = $btn.attr("id").substring($btn.attr("id").lastIndexOf("-")+1);
    var action = $editCateForm.attr("action");
    $editCateForm.attr("action",action.substring(0,action.lastIndexOf("/")+1)+id);
    $editCateDialog.find("#name").val(name);
    $editCateDialog.dialog('open');
  });
  // Category Add Button
  $tabBox.find('button.cate-add').button({
    icons: {
      primary: "ui-icon-plus"
    }
  }).click(function(){
    $addCateDialog.dialog('open');
  });
}

function prepareUsers(){
  // Search
  $("#search-user-btn").button({
    text: false,
    icons: {
        primary: "ui-icon-search"
    }
  });
  $("#user-search-form")
  .bind("ajax:success", function(evt, data, status, xhr){
    $tabBox.html(xhr.responseText);
    prepareUsers(); 
  });
  // Pagination
  $('.users-pagination a').attr('data-remote','true')
  .bind("ajax:complete", function(evt, xhr, status){
    $tabBox.html(xhr.responseText);
    prepareUsers(); 
  });
  $tabBox = $('#tab-box').addClass("tab-content");
  // Hidden Edit Form and Input
  $editUserForm = $('#edit-user-form')
  .bind('ajax:error', function(evt, xhr, status, error){
    var user = $.parseJSON(xhr.responseText);
    if(user.admin)
      $("#admin_radio"+user.id+"_yes").attr("checked","checked").button("refresh");
    else
      $("#admin_radio"+user.id+"_no").attr("checked","checked").button("refresh");
    if(user.active)
      $("#active_radio"+user.id+"_yes").attr("checked","checked").button("refresh");
    else
      $("#active_radio"+user.id+"_no").attr("checked","checked").button("refresh");
    alert("操作失败");
  });
  $adminInput =$("#admin");
  $activeInput =$("#active");
  // User Admin Radio
  $adminRadioSets = $("div.admin-radio").buttonset();
  for(var i=0;i<$adminRadioSets.length;i++){
    $($adminRadioSets[i]).children(":first").button({
      text: false,
      icons: {
          primary: "ui-icon-check"
      }
    }).change(function(){ 
      submitEditUserForm(this.value,true,null,$editUserForm,$adminInput,$activeInput);
    })
    .next().next().button({
      text: false,
      icons: {
          primary: "ui-icon-close"
      }
    }).change(function(){
      submitEditUserForm(this.value,false,null,$editUserForm,$adminInput,$activeInput);
    });
  }
  // User Active Radio
  $activeRadioSets = $("div.active-radio").buttonset();
  for(var i=0;i<$activeRadioSets.length;i++){
    $($activeRadioSets[i]).children(":first").button({
      text: false,
      icons: {
          primary: "ui-icon-unlocked"
      }
    }).change(function(){ 
      submitEditUserForm(this.value,null,true,$editUserForm,$adminInput,$activeInput);
    })
    .next().next().button({
      text: false,
      icons: {
          primary: "ui-icon-locked"
      }
    }).change(function(){
      submitEditUserForm(this.value,null,false,$editUserForm,$adminInput,$activeInput);
    });
  }
}

function prepareHelp(helpId,helpShadowId,helpContentId){
  var $help = $(helpId);
  if($help.length > 0){
    var $helpShadow = $(helpShadowId).hide();
    var $helpContent = $(helpContentId).hide();
    offleft = $help.position().left - $helpShadow.width()/2; 
    offtop = $help.position().top - $helpShadow.height()- 10;
    $helpShadow.css({left:offleft,top:offtop});
    $helpContent.css({left:offleft,top:offtop});
    $help.hover(
      function(){
        $helpShadow.show();
        $helpContent.show();
      },
      function(){
        $helpShadow.hide();
        $helpContent.hide();
      }
    );
  }
}

$(function(){
  /* Button */
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
    text:false, 
    icons: {
	  primary: "ui-icon-search"
	}
  });
  $('#add-idea').button();
  $('#preview-idea').button().click(function(){
    var description = $('#idea_description').val();
    if($.trim(description)!=''){
       $.post('/ideas/preview',{description:description},function(data){
        if(data){
          $previewDialog.html(data);
          $previewDialog.dialog('open');
        }
      });
    }
  });
  $('#preview-comment').button().click(function(){
    var description = $('#comment_content').val();
    if($.trim(description)!=''){
       $.post('/ideas/preview',{description:description},function(data){
        if(data){
          $previewCommentDialog.html(data);
          $previewCommentDialog.dialog('open');
        }
      });
    }
  });
;
  $('#edit-idea').button();
  $('#handle-idea').button();
  $('#add-comment').button();
  $('#add-cate').button();
  /* Tab */
  // Ideas Tab
  var $tabs = $('#tabs').tabs({
    select:function(event,ui){
      var style = ui.index 
      var cate_id=$('#category_id').val();
      $.data(ui.tab,'load.tabs','/ideas/tab?'+
        $.param({style:style,cate_id:cate_id}));
    },
    load: function(event, ui) {
      prepareIdeas(); 
    }
  });
  var $searchTabs = $("#search-tabs").tabs();
  $("#admin-tabs").tabs({
    load: function(event, ui) {
      switch(ui.index){
        case 0:prepareCategories();break
        case 1:prepareUsers();break
      }
    } 
  });
  /* Dialog */
  $('#login-dialog').dialog({
    modal:true,
    autoOpen:false
  });
  $promotionDialog=$('#promotion-dialog').dialog({
    height: 500,
    width: 600,
    modal:true,
    autoOpen:false
  });
  $previewDialog=$('#preview-dialog').dialog({
    height: 300,
    width: 500,
    modal:true,
    autoOpen:false
  });
  $previewCommentDialog=$('#preview-comment-dialog').dialog({
    height: 200,
    width: 450,
    modal:true,
    autoOpen:false
  });

  /* AJAX */
  // Category Link AJAX
  if($tabs.length > 0){
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
  // Idea Search AJAX
  var $searchform=$('#search-form').submit(function(){
    if($.trim($('#query').val())=='')
      return false;
  });
  if($searchTabs.length > 0){
    $searchform.attr('data-remote','true')
    .bind("ajax:complete", function(evt, xhr, status){
      showSearchTab(xhr.responseText);
    });
  }
  // Idea Promotion AJAX Dialog
  $('#idea_title').focus().focusout(function(){
    if($.trim(this.value)!=''){
      $.get('/ideas/promotion',{title:this.value},function(data){
        if(data){
          $promotionDialog.html(data);
          $promotionDialog.dialog('open');
        }
      });
    }
  });
  // Init
  makeVoteButton();
  prepareComments();
  prepareHelp('#leadboard-help','#leadboard-help-shadow','#leadboard-help-content');
  prepareHelp('#newidea-help','#newidea-help-shadow','#newidea-help-content');
});
