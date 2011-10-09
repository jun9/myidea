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
});
