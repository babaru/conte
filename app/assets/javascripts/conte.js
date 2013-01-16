function toggleSubMenu() {
  $('.child').hide();
  $('.parent').children().click(function() {
    if ($(this).hasClass('toggle')) {
      $(this).removeClass('toggle');
    } else {
      $(this).addClass('toggle');
    }
    $(this).children('.child').slideToggle('slow');  
  }).children('.child').click(function (event) {
    event.stopPropagation();
  });
}