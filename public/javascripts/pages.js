$(document).ready(function($){

$("body").ajaxSuccess(function(){
});

$(".header a").click(function(event){
  event.preventDefault();
  url = $(this).attr("href");
  $.ajax({
    url: url + "?format=js", type: 'get', dataType: 'html',
    success: function(data, status, xhr){
      $(".main-content").html(data);
    }
  });
});

});
