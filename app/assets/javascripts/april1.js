$(function() {
  $('#a1-retina-mode').click(function() {
    body = $('body');
    if (!body.hasClass('april1-comic')) {
      body.addClass('april1-comic');
      $(this).text("Colour Mode");

    } else if (!body.hasClass('april1-rainbow')) {
      body.addClass('april1-rainbow');
      $(this).text("Flip it off")

    } else if (!body.hasClass('april1-flip')) {
      body.addClass('april1-flip');
      $(this).text("Turn off for real")

    } else {
      alert("I LOVE THAT YOU'RE STILL TRYING!");
    }
    return false;
  });
});