$(function(){
  
  $('#flash a.closer').click(function() {
    $('#flash').animate({ height: 0, opacity: 0, marginTop: "-10px", marginBottom: "-10px" }, 'slow');
    $('#flash a.closer').hide();
    return false;
  });
  
  // toggle_form links toggle the next form
  $(".toggle_form").live("click", function(e){
    var link = $(this).hide();
    link.next("form").show();
    
    e.preventDefault();
  });
  
  // date picker
  $('.datepicker').datepicker({
    showOn: "button",
    buttonText: "Select",
    dateFormat: 'yy-mm-dd' 
  });
});