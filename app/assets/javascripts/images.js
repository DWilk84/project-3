// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


getFacebookImages = function(){
  console.log("clicked")
  $this = $(this);
  $this.removeClass("fb-btn-unclicked")

  var $body = $('body');
  // $body.addClass('loading');

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
    $fb_album_select.css("display", "block");
  $body.removeClass('loading');
  });
};

removeSpaces = function(string){
  return string.replace(/\s+/g, '')
}

toggleAlbumShow = function(){
  $('.album_active').toggleClass('album_active');
  id = $('#fb_album_select').val();
  $('.' + id).closest('.fb_image_container').toggleClass('album_active');
}

addToUploadedImages = function(data){
  var id = data.id;
  var url = data.file.url;
  // debugger;
  var element = $('<div class="uploaded_image_container" id="' + id + '">' +
    '<img alt="" src="' + url + '" class="uploaded_image"/>' +
    '</div>')
  element.prependTo('#uploaded_images_inner');
  enableNext();
};

toggleImageSelect = function(){
  var $this = $(this);
  // debugger;
  $this.toggleClass('image_selected');
};

addAlbumSelect = function(){
  id = $('#fb_album_select').val();
  $('.' + id).parent().addClass('image_selected');
}

removeAlbumSelect = function(){
  id = $('#fb_album_select').val();
  $('.' + id).parent().removeClass('image_selected');
}

uploadFBImages = function(){
  var pics = $('.fb_image_container.image_selected > img');
  // debugger;
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
    }).success(function(result){
      addToUploadedImages(result);
      // v.src
    });
  });
  pics.parent().removeClass('image_selected');
}

enableNext = function(){
  var num_images = $('#uploaded_images_inner img').length;
  if (num_images > 0) {
    $("#btn_step_2").removeClass("disabled");
  };
};

deleteAll = function(){
  var images = $('.uploaded_image_container');
  deleteImages(images);
};

deleteSelected = function(){
  var images = $('.uploaded_image_container.image_selected');
  deleteImages(images);
}

deleteImages = function(images){
  $.each(images, function(k, v){
    $.ajax({
      url: "/images/" + v.id,
      type: "DELETE",
      dataType: "JSON",
    }).success(function(){
      $('#' + v.id).remove();
    });
  });
};

$(function(){

  $('#fb-btn-container').on('click', '.fb-btn-unclicked', getFacebookImages);

  $('#fb_album_select').on('change', toggleAlbumShow);

  $('#fb-modal').on('click', '.fb_image_container', toggleImageSelect);
  $('#fb-modal').on('click', '#select_all', addAlbumSelect);
  $('#fb-modal').on('click', '#deselect_all', removeAlbumSelect);
  $('#fb-modal').on('click', '#add_to_images', uploadFBImages);
  $('#uploaded_images').on('click', '.uploaded_image_container', toggleImageSelect );
  $('#delete_all_images').on('click', deleteAll);
  $('#delete_selected_images').on('click', deleteSelected);

  // multi file upload
  $('#new_image').fileupload({
    dataType: "JSON",
    done: function (e, data) {
      addToUploadedImages(data.result);
    },
    progress: function (e, data) {
      var progress = parseInt(data.loaded / data.total * 100, 10);
      $('#progress .bar').css(
          'width',
          progress + '%'
      );
    }
  });

  enableNext();
});