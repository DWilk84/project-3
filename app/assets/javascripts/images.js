// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
  $('.fb_pic').on('click', function(){
    var $this = $(this);
    $this.toggleClass('selected');
  });

  $('.add_album').on('click', function(){
    // debugger
    var $this = $(this);
    var $album_container = $this.closest('.album_container');
    $album_container.find('.fb_pic').addClass('selected');
  });

  $('.add_all_albums').on('click', function(){
    var $this = $(this);
    var $fb_select = $this.closest(".fb_select");
    $fb_select.find('.fb_pic').addClass('selected');
  });

  $('.upload_fb_pics').on('click', function(){
    var $pics = $('.fb_pic.selected');
    debugger;
  });


});