$(document).ready(function($){

$("body").ajaxSuccess(function(){
});

$("a.ajax").live("click",function(event){
  event.preventDefault();
  url = $(this).attr("href");
  title = $(this).text();
  $.ajax({
    url: url + "?format=js", type: 'get', dataType: 'html',
    success: function(data, status, xhr){
      $("#popup").html(data).dialog({ width: 750, height: 550, maxHeight: 600, title: title });
    }
  });
});


});
