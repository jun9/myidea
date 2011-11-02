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
  /* buttons */
  $('#pub-idea').button({
    icons: {
	  primary: "ui-icon-lightbulb"
	}
  });
  $('#searchBtn').button({
    icons: {
	  primary: "ui-icon-search"
	}
  });
  /* ajax */
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
/* make ideas ui and event ready */
function prepareIdeas(){
  $('.vote-disabled').button({disabled:true});
  $('.vote-toggle').button().click(function(){
      vote_btns = $(this).parent().children();
      $vote_btn_y = $(vote_btns[0]);
      $vote_btn_n = $(vote_btns[1]);
      $point_text = $vote_btn_y.parent().next().find("strong");
      if(this.title){
        $('#login-dialog').dialog("open");
      }
      else if(vote_btns[0] == this){
        $.post('/ideas/'+vote_btns[0].value+'/like',function(idea){
          $vote_btn_y.button({disabled:true});
          $vote_btn_n.button({disabled:true});
          $point_text.text(idea.points);
        });
      }else if(vote_btns[1] == this){
        $.post('/ideas/'+vote_btns[1].value+'/unlike',function(idea){
          $vote_btn_y.button({disabled:true});
          $vote_btn_n.button({disabled:true});
          $point_text.text(idea.points);
        });
      }
    });
 
  /* category select */
  $('#category_id').change(function(){
    var style = $('#tabs').tabs('option','selected')
    $.get('/ideas/tab',{cate_id:this.value,style:style},function(data){
      showIdeasTab(data);
    })
  });
  /* make ideas pagination ajax */
  $('.ideas-pagination a').attr('data-remote','true')
  .bind("ajax:success", function(evt, data, status, xhr){
    showIdeasTab(xhr.responseText);
  });
 /* make ideas pagination ajax */
  $('.search-pagination a').attr('data-remote','true')
  .bind("ajax:complete", function(evt, xhr, status){
    showSearchTab(xhr.responseText);
  });
}
/* ajax show ideas tab partial */
function showIdeasTab(data){
  $('#tab-box').html(data);
  prepareIdeas(); 
}
function showSearchTab(data){
  $("#search-tabs-box").html(data);
  prepareIdeas();

}
function prepareComments(){
  /* make ideas pagination ajax */
  $('.comments-pagination a').attr('data-remote','true')
  .bind('ajax:complete', function(evt, xhr, status){
    $("#comments").html(xhr.responseText);
    prepareComments();
  });
}
