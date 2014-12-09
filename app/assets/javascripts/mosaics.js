// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
  $('select').imagepicker({});

  $('#add_all').on('click', function(){
    // debugger;
    event.preventDefault();
    $('#tiles').find('option').attr('selected', true);
    $('#tiles').find('.thumbnail').addClass('selected');
  });

  $('#remove_all').on('click', function(){
    event.preventDefault();
    $('#tiles').find('option').attr('selected', false);
    $('#tiles').find('.thumbnail').removeClass('selected');
  });
});