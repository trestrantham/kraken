$(document).ready(function(){
    $("html").niceScroll({
        scrollspeed:5,
        cursorcolor:"#BDBDBD",
        cursorborder:"none",
        cursorborderradius:0,
        zindex:10,
        hidecursordelay:100
    });

    $(window).trigger("resize");
});
