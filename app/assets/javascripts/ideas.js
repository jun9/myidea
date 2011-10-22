$(function(){
    prepareIdeas();
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
  $('.vote-toggle').button().click(function(){
      $vote_btn = $(this);
      $vote_span = $vote_btn.children();
      $point_text = $vote_btn.parent().next().find("strong");
      if($vote_btn.hasClass("vote-yes")){
        $.post('/ideas/'+$vote_btn.val()+'/like',function(idea){
          $vote_btn.removeClass("vote-yes");
          $vote_btn.addClass("vote-no");
          $vote_span.text("踩");
          $point_text.text(idea.points);
        });
      }else if($vote_btn.hasClass("vote-no")){
        $.post('/ideas/'+$vote_btn.val()+'/unlike',function(idea){
          $vote_btn.removeClass("vote-no");
          $vote_btn.addClass("vote-yes");
          $vote_span.text("顶");
          $point_text.text(idea.points);
        });
      }else{
        $('#login-dialog').dialog("open");
      }
    });
 
  /* category select */
  $('#category_id').change(function(){
    var style = $('#tabs').tabs('option','selected')
    $.get('/ideas/tab',{cate_id:this.value,style:style},function(data){
      showIdeasTab(data);
    })
  });
  /* make pagination ajax */
  $('.pagination > a').attr('data-remote','true')
  .bind("ajax:success", function(evt, data, status, xhr){
    showIdeasTab(xhr.responseText);
  });
}
/* ajax show ideas tab partial */
function showIdeasTab(data){
  $('#tab-box').html(data);
  prepareIdeas(); 
}
