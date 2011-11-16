$(function(){
    prepareIdeas();
    prepareComments();
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
    $("#search-tabs").tabs();
    $("#admin-tabs").tabs({
      load: function(event, ui) {
        switch(ui.index){
          case 0:prepareCategories();break
          case 1:prepareUsers();break
        }
      } 
    });
    $('#add-idea').button();
    $('#add-comment').button();
    $('#add-cate').button();
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
});

