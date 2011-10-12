$(function(){
    prepareIdeas();
    /* dialog */
    $promotionDialog=$('#promotion-dialog').dialog({
        height: 500,
        width: 600,
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
  $('.vote-toggle').button();    
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
