$(function () {
  $('#question_outcome_id').chosen();
  $('#add-question-option').on('click', function (e) {
    e.preventDefault();
    var questionOptions = $('.question-option');
    var lastOptionCopy = questionOptions.last().clone();
    if (!lastOptionCopy.length) {
      alert('Could not find option template.');
      return;
    }
    var firstControlName = lastOptionCopy.find('.form-control:first').attr('name');
    if (!firstControlName) {
      alert('Could not find a named form control.');
      return;
    }
    var lastOptionIndex = parseInt(firstControlName.replace(/\D+/, ''));
    if (Number.isNaN(lastOptionIndex)) {
      alert('Could not determine last option index.');
      return;
    }
    var newIndex = lastOptionIndex + 1;
    lastOptionCopy.find('textarea').val('');
    lastOptionCopy.find('[type=checkbox]').attr('checked', false);
    var attrWithOldIdxRe = new RegExp('^(.*\\D)' + lastOptionIndex + '(\\D.*)$');
    var attrWithNewIdxReplacer = function (match, $1, $2) {
      return $1 + newIndex + $2;
    };
    ['id', 'name', 'for'].forEach(function (attr) {
      lastOptionCopy.find('[' + attr + '*=' + lastOptionIndex + ']').each(function (idx, el) {
        var $el = $(el);
        var newValue = $el.attr(attr).replace(attrWithOldIdxRe, attrWithNewIdxReplacer);
        $el.attr(attr, newValue);
      });
    });
    questionOptions.parent().append(lastOptionCopy);
    $('html, body').animate({
        scrollTop: lastOptionCopy.offset().top
    }, 2000);
  });
});

