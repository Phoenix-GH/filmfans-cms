$(function() {
  var isChange = false;

  $( "input" ).change(function() {
    if($(this).attr('placeholder') && $(this).attr('placeholder').toLowerCase().indexOf('search') > -1) return;
    if($(this).attr('name') && $(this).attr('name').toLowerCase().indexOf('search') > -1) return;
    if($(this).attr('id') && $(this).attr('id').toLowerCase().indexOf('search') > -1) return;
    isChange = true;
  });

  $('input[type="submit"]').click(function(){
    isChange = false;
  });

  window.onbeforeunload = function(event) {
    var return_text = "You have made some changes which you might want to save.";
    if(isChange) {
      event.returnValue = return_text;
      isChange = false;
      return return_text;
    }
  };
});
