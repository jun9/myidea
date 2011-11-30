function prepareActivities(){
  $('.activities-pagination a').attr('data-remote','true')
  .bind('ajax:complete', function(evt, xhr, status){
    $("#tab-box").html(xhr.responseText);
    prepareActivities();
  });
}

$(function(){
    $('#login').button();			
    $("#user-tabs").tabs({
      load: function(event, ui) {
        prepareActivities();
      } 
    });
});
