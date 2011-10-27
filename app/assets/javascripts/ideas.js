$(function(){
    prepareIdeas();
    prepareComments();
    /* dialog */
    $promotionDialog=$('#promotion-dialog').dialog({
        height: 500,
        width: 600,
        modal:true,
        autoOpen:false
    });
    $('#login-dialog').dialog({
        modal:true,
        autoOpen:false
    });

    /* tabs */
	$('#tabs').tabs({
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
    /* buttons */
    $('#add-idea').button();
    $('#add-comment').button();
    /* input */
    $('#idea_title').focus().focusout(function(){
      $.get('/ideas/promotion',{title:this.value},function(data){
        $promotionDialog.html(data);
        $promotionDialog.dialog('open');
      });
    });
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
}
/* ajax show ideas tab partial */
function showIdeasTab(data){
  $('#tab-box').html(data);
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
