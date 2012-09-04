// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .

//public/javascripts/application.js
//"ajax:beforeSend" and "ajax:complete" event hooks are provided by Rails 3's jquery-ujs driver.
$("*[data-spinner]").live('ajax:beforeSend', function(e){
  $($(this).data('archive_form_spinner')).show();
  e.stopPropagation(); //Don't show spinner of parent elements.
});
$("*[data-spinner]").live('ajax:complete', function(){
  $($(this).data('archive_form_spinner')).hide();
});
