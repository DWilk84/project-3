// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){
  var $nav_links = $(".scroll_link");

  $nav_links.on("click", function(event){
    event.preventDefault();
    $.scrollTo(
      $(this).attr("href"),
      {
        duration: 500,
        offset: {
          "left": 0,
          "top": -75
        }
      }
    );
  });
});