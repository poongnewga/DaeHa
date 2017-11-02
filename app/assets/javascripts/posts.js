// 도큐먼트 = 윈도우 + 스크롤
var page = 1;
$(window).scroll(function() {
  if (window.location.pathname != "/posts/index") {

    if (( $(window).height() + $(window).scrollTop() )>=($(document).height()-300)) {
        console.log("도착");
        console.log(page);
        $( "body" ).append( "<div style='min-height: 1500px;' class='page-" + page  + "'></div>");
        // #ajax 링크의 page를 바꾼다.
        $("#ajax").attr("href", (window.location.pathname + "/" + page))
        console.log(window.location.pathname + "/" + page);
        // 링크를 클릭한다.
        $("#ajax").click();
        page++;
    }
  }
    // console.log("document: " + $(document).height())
    // console.log("window: " + ($(window).height() + $(window).scrollTop()))
    // console.log("scroll: " + $(window).scrollTop())
});


$(document).ready(function() {

  // $('.navbtn').click(function(){
  //     $('html, body').animate({scrollTop: 0}, 500);
  //     return false;
  // });

  // $('.reactions-total').on("click", function(){
  //   $(this).next('.reactions').toggleClass("reaction-visible");
  // });

});

$(document).on('turbolinks:load', function() {
  $('.navbtn').click(function(){
      $('html, body').animate({scrollTop: 0}, 500);
      return false;
  });

  $('.reactions-total').on("click", function(){
    $(this).next('.reactions').toggleClass("reaction-visible");
  });
});
