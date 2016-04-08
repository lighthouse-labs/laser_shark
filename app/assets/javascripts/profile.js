(function() {
  function manageFileSelection($fileField, params) {
    $fileField.change(params, function(evt) {
      var reader = evt.data.reader;
      var file = evt.target.files[0];

      reader.readAsDataURL(file);

      if (!file || !file.type.match('image.*')) {
        // Ignore user's file selection by reseting fileField value as follows:
        this.value = '';
      } else {
        // `reader` automatically executes callback `onloadend`
      }
    });
  }

  /**
   * Provide error feedback if the selection was not an image file
   * @param  {Boolean} isValid
   * @param  {jQuery}  $img
   * @param  {jQuery}  $msg
   */
  function provideErrorFeedback(isValid, $img, $msg) {
    if (isValid) {
      $img.removeClass('invalid-image');
      $msg.fadeOut();
    } else {
      $img.addClass('invalid-image');
      $msg.fadeIn();
    }
  }

  function isAnImage(file) {
    return file.split(';')[0].split(':')[1].split('/')[0] === 'image';
  }

  /**
   * Display a new Avatar if an image file has been selected.
   * Upon failure revert back to original image
   * @param  {jQuery} $img         image
   * @param  {blob} file         base64 representation of file selection
   * @param  {String} original_img
   * @return {bool}              communicate success/failure of displaying new avatar
   */
  function displayNewAvatar($img, file, original_img) {
    var isImage = isAnImage(file);
    var avatar = isImage ? file : original_img;

    $img.attr('src', avatar);
    return isImage; // if not an image, then return false
  }

  function manageAvatarLoading() {
    var $img = $('.avatar-format img');
    var $fileField = $('[name="user[custom_avatar]"]');
    var $msg = $('.alert.alert-error.invalid-image-selection');
    var original_img = $img[0].src;

    var reader = new FileReader();
    reader.onloadend = function (evt) {
      var isImage = displayNewAvatar($img, reader.result, original_img);
      provideErrorFeedback(isImage, $img, $msg);
    }

    var params = { reader: reader };
    manageFileSelection($fileField, params);
  }

  window.Profile = {
    manageAvatarLoading: manageAvatarLoading
  }
})()