// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

selectAll = function(){
  event.preventDefault();
  $('#tiles').find('option').attr('selected', true);
  $('#tiles').find('.thumbnail').addClass('selected');
};

removeAll = function(){
  event.preventDefault();
  $('#tiles').find('option').attr('selected', false);
  $('#tiles').find('.thumbnail').removeClass('selected');
}

tabSelect = function(){
  var $this = $(this);
  $this.addClass('active');
  $this.siblings().removeClass('active');
  bodySelect($this);
}

bodySelect = function(element){
  var id = element.attr('id').replace('tab', 'body');
  var $this = $('#' + id)
  $('.body_tab').fadeOut();
  $this.fadeIn();
}

goToStep2 = function(){
  $this = $('#mosaic_tab_pick_target')
  $this.addClass('active');
  $this.siblings().removeClass('active');
  bodySelect($this);
}

goToStep3 = function(){
  console.log('form submitted')
  $('#new_mosaic').submit();
}

submitForm = function(){
  event.preventDefault();
  var $body = $('body');
  $body.addClass('loading');

  var $this = $(this);
  var data = {}
  data['name'] = $('#mosaic_name').val();
  var images = $('#tiles #mosaic_image_ids_').val();
  images.push($('#target #mosaic_image_ids_').val());
  data['image_ids'] = images
  $.ajax({
    url: "/mosaics/",
    type: "POST",
    data: {mosaic: data},
    dataType: "JSON"
  }).success(function(response){
    $mosaic_name = $('#mosaic_name')
    $mosaic_show = $('#mosaic_show')
    $body.removeClass('loading');
    var element = $('<div><h3>' + response.name + '</h3></div>');
    element.appendTo($mosaic_name);

    var element = $('<div id="mosaic_container">' +
        '<img alt="' + response.name + '" data-zoom-image="' + response.path + '" id="zoom_01" src="' + response.path_small + '" />' +
      '</div>');
    element.appendTo($mosaic_show);

    $mosaic_body_show_mosaic = $('#mosaic_body_show_mosaic');
    $mosaic_tab_show_mosaic = $('#mosaic_tab_show_mosaic');
    $mosaic_tab_show_mosaic.addClass('active');
    $mosaic_tab_show_mosaic.siblings().removeClass('active');
    bodySelect($mosaic_body_show_mosaic);

    $('#zoom_01').elevateZoom({
      tint:true,
      tintColour:'#000',
      tintOpacity:0.3,
      zoomWindowFadeIn: 500,
      zoomWindowFadeOut: 500,
      lensFadeIn: 500,
      lensFadeOut: 500,
      zoomWindowOffetx: 20,
      // zoomWindowPosition: "mosaic_zoom",
      zoomWindowHeight: 300,
      zoomWindowWidth:300,
      // borderSize: 0,
      easing:true
      // scrollZoom : true
    });
  });
}

$(function(){
  $('select').imagepicker({});
  $('#add_all').on('click', selectAll);
  $('#remove_all').on('click', removeAll);
  $('.tab_selector').on('click', tabSelect);
  $('#go_to_step_2').on('click', goToStep2);
  $('#go_to_step_3').on('click', goToStep3);
  $('#new_mosaic').on('submit', submitForm);

  $('#zoom_01').elevateZoom({
    tint:true,
    tintColour:'#000',
    tintOpacity:0.3,
    zoomWindowFadeIn: 500,
    zoomWindowFadeOut: 500,
    lensFadeIn: 500,
    lensFadeOut: 500,
    zoomWindowOffetx: 20,
    // zoomWindowPosition: "mosaic_zoom",
    zoomWindowHeight: 300,
    zoomWindowWidth:300,
    // borderSize: 0,
    easing:true
    // scrollZoom : true
    });
});