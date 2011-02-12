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
//      $("#popup").html(data).dialog({ width: 750, height: 550, maxHeight: 600, title: title });
      $("#popup > .popup-header > div.title").html(title);
      $("#popup > p.body").html(data).parent().show();

    }
  });
});

$(".popup").toggle();

$(".popup-close").live("click",function(event){
  event.preventDefault();
  $(this).parent().parent().hide();
});

});
