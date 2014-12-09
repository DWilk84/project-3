// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
  $('select').imagepicker({});

  $('#add_all').on('click', function(){
    $('option').attr('selected', true);
    $('.thumbnail').addClass('selected');
  });

  $('#remove_all').on('click', function(){
    $('option').attr('selected', false);
    $('.thumbnail').removeClass('selected')
  });
});