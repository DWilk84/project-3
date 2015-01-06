// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

toggleTargetSelect = function(){
  $this = $(this);
  $('.target_image_container').removeClass('image_selected');
  $this.addClass('image_selected');
}

goToStep3 = function(){
  console.log('goToStep3 clicked');
}

createMosaic = function(){
  var target = parseInt($('.image_selected').attr('id'));
  var name = $('#name_input').val();
  var pics = $('.target_image_container');
  image_ids = []
  $.each(pics, function(k, v){
    image_ids.push(parseInt(v.id));
  });
  image_ids.push(target);
  var data = {};
  data['name'] = name
  data['image_ids'] = image_ids
  
  $.ajax({
    url: "/mosaics/",
    type: "POST",
    data: {mosaic: data},
    dataType: "JSON"
  }).success(function(response){
    console.log(response);
    window.location.href = response.id.toString()
  });
};

activateZoom = function(){
    $('#zoom_01').elevateZoom({
      zoomType: 'inner',
      cursor: 'crossair',
      zoomWindowFadeIn: 500,
      zoomWindowFadeOut: 500,
      easing: true,
    });
};

$(function(){
  $('.target_image_container').on('click', toggleTargetSelect);
  $('#btn_step_3').on('click', goToStep3);
  $('#btn_create_pixelpic').on('click', createMosaic);

  activateZoom();
});