$(function(){
  
  // toggle_form links toggle the next form
  $(".toggle_form").live("click", function(e){
    var link = $(this).hide();
    link.next("form").show();
    
    e.preventDefault();
  });
});