$(function(){
    $('#login').button();			
    $("#user-tabs").tabs({
      load: function(event, ui) {
        prepareActivities();
      } 
    });
});
