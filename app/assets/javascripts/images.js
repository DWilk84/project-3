// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggleActiveForm = function(){
  var $this = $(this);
  var sibling = $(this).siblings();
  $this.toggleClass('active inactive');
  sibling.toggleClass('active inactive');

  if ($("#upload_selector_file").hasClass('active')) {
    $('#upload_from_fb').slideUp(function(){
      $('#upload_from_file').slideDown();
    });
  } else {
    $('#upload_from_file').slideUp(function(){
      $('#fb_album_select').css('display', 'block')
      $('#upload_from_fb').slideDown();
    });

    if ($('#upload_selector_fb').hasClass('get_from_fb')) {
      $this.removeClass('get_from_fb');
      getFacebookImages();
    };
  };
};

getFacebookImages = function(){

  var $body = $('body');
  $body.addClass('loading');

  var $fb_album_select = $('#fb_album_select');
  var $fb_albums = $('#fb_albums');

  $.ajax({
    url: "/images",
    type: "GET",
    dataType: "JSON",
  }).success(function(data){

    $.each(data, function(k, album){
      var album_name = album.name;
      var album_value = removeSpaces(album.name);
      var new_option = $('<option value="'+album_value+'">'+album_name+'</option>');
      new_option.appendTo($fb_album_select);

      var image_urls = album.urls
      $.each(image_urls, function(k, image_url){
        var element = $('<div class="fb_image_container">' +
            '<img class="fb_image ' + album_value + '" alt="' + album_name + '" src="' + image_url + '" />' +
          '</div>')
        element.appendTo($fb_albums)
      });
    });
  });
  // debugger
  $body.removeClass('loading');
};

removeSpaces = function(string){
  return string.replace(/\s+/g, '')
}

toggleAlbumShow = function(){
  $('.album_active').toggleClass('album_active');
  id = $('#fb_album_select').val();
  $('.' + id).closest('.fb_image_container').toggleClass('album_active');
}

addToFacebookImages = function(image_url){
  // add to images db, then append to uploaded images div
  var element = $('<div class="uploaded_image">' +
    '<img alt="" src="' + image_url + '" />' +
    '</div>')
  element.prependTo('#uploaded_images_inner');
};

addToUploadedImages = function(image_url){
  var element = $('<div class="uploaded_image_container">' +
    '<img alt="" src="' + image_url + '" />' +
    '</div>')
  element.prependTo('#uploaded_images_inner');
};

toggleImageSelect = function(){
  var $this = $(this);
  $this.toggleClass('selected');
};

addAlbumSelect = function(){
  console.log('add album');
  id = $('#fb_album_select').val();
  $('.' + id).addClass('selected');
}

uploadFBImages = function(){
  var pics = $('.fb_image.selected');
  $.each(pics, function(k, v){
    var data = {
      remote_file_url: v.src,
      name: "fb_upload_pic"
    };
    $.ajax({
      url: "/images",
      type: "POST",
      dataType: "JSON",
      data: {image: data}
    }).success(addToUploadedImages(v.src));
  });
  pics.removeClass('selected');
}

$(function(){
  $('#upload_selector_file').on('click', toggleActiveForm);
  $('#upload_selector_fb').on('click', toggleActiveForm);
  $('#fb_album_select').on('change', toggleAlbumShow);
  $('#upload_from_fb').on('click', '.fb_image', toggleImageSelect);
  $('#upload_from_fb').on('click', '#add_album', addAlbumSelect);
  $('#upload_from_fb').on('click', '#upload_fb_images', uploadFBImages);

  // multi file upload
  $('#new_image').fileupload({
    dataType: "JSON",
    done: function (e, data) {
      addToUploadedImages(data.result.file.url);
    },
    progress: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $('#progress .bar').css(
          'width',
          progress + '%'
      );
    }
  });
});