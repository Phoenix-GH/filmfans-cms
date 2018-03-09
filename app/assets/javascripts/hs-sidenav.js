$(function() {
  // $('.nav-sidebar .sub-menu > a').click(function(e) {
  //   $('.nav-sidebar ul ul').slideDown(),
  //    $(this).next().is(':visible') || $(this).next().slideDown(),
  //   e.stopPropagation()
  // });
  $('.nav-sidebar > .sub-menu').on('click', '> a', function(event) {
    event.preventDefault();
    $('.nav-sidebar .sub-menu ul').slideUp();
    $('.nav-sidebar .sub-menu').removeClass('active');
    if ($(this).next().is(':visible')) {
      $(this).next().slideUp();
      $(this).parent().removeClass('active');
    } else {
      $(this).next().slideDown();
      $(this).parent().addClass('active');
    }
  });
  $('.nav-sidebar > .sub-menu .sub-menu').on('click', '> a', function(event) {
    event.preventDefault();
    $('.nav-sidebar .sub-menu ul').removeClass('active');
    $('.nav-sidebar > .sub-menu .sub-menu').removeClass('active');
    $('.nav-sidebar > .sub-menu .sub-menu ul').slideUp();
    if ($(this).next().is(':visible')) {
      $(this).next().slideUp();
      $(this).parent().removeClass('active');
      $(this).parent().parent().removeClass('active');
    } else {
      $(this).next().slideDown();
      $(this).parent().addClass('active');
      $(this).parent().parent().addClass('active');
    }
  });

  $('.active').closest('.sub-menu').addClass('active');
  $('.active').parent().parent().addClass('active');
});
