function showFlash(alertFlash){
  $('#flash').html('<div class="ui-state-error ui-corner-all error-msg"><div><span class="ui-icon ui-icon-alert msg"></span>'+alertFlash+'<a href="javascript:closeFlash();" style="float:right"><span class="ui-icon ui-icon-closethick">close</span></a></div><div class="clear"></div></div>');
}
function closeFlash(){
  $('#flash').empty();
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
        $(this).dialog("close");
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
        $(this).dialog("close");
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
    showFlash('操作失败');
  })
  .bind("ajax:success", function(evt, data, status, xhr){
    closeFlash();
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
  $('#idea-description-tabs').tabs();
  $('#comment-content-tabs').tabs();
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
  // Idea Preview AJAX
  $descriptionInput = $('#idea-preview-content');
  $ideaTextPreview = $('#idea-text-preview'); 
  $previewIdeaForm = $('#preview-idea-form')
  .bind("ajax:beforeSend", function(evt, xhr, settings){
    $ideaTextPreview.empty();
    $ideaTextPreview.addClass("loading");
  })
  .bind("ajax:success", function(evt, data, status, xhr){
    $ideaTextPreview.removeClass("loading");
    $ideaTextPreview.html(xhr.responseText);
  });
  $('#preview-idea').click(function(){
    var description = $('#idea_description').val();
    if($.trim(description)!=''){
       $descriptionInput.val(description);
       $previewIdeaForm.submit();
    }
  });
  $commentTextPreview = $('#comment-text-preview');
  $contentInput = $('#comment-preview-content');
  $previewCommentForm = $('#preview-comment-form')
  .bind("ajax:beforeSend", function(evt, xhr, settings){
    $commentTextPreview.empty();
    $commentTextPreview.addClass("loading");
  })
  .bind("ajax:success", function(evt, data, status, xhr){
    $commentTextPreview.removeClass("loading");
    $commentTextPreview.html(xhr.responseText);
  });
  $('#preview-comment').click(function(){
    var description = $('#comment_content').val();
    if($.trim(description)!=''){
       $contentInput.val(description);
       $previewCommentForm.submit();
    }
  });
  // Init
  makeVoteButton();
  prepareComments();
  $("#guide").accordion({header:"h3",autoHeight:false,event:"mouseover"});
});
