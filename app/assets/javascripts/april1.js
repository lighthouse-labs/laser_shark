$(function() {
  $('#a1-retina-mode').click(function() {
    body = $('body');
    if (!body.hasClass('april1-comic')) {
      body.addClass('april1-comic');
    } else if (!body.hasClass('april1-rainbow')) {
      body.addClass('april1-rainbow');
    } else if (!body.hasClass('april1-flip')) {
      body.addClass('april1-flip');
    } else {
      alert("I LOVE THAT YOU'RE STILL TRYING!");
    }
    return false;
  });
});