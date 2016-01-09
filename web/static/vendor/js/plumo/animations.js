var Animations_Exemple = (function () {

    var selector = ".animations_example";

    var init = function(){
        
        if( $(selector).length ){
            listener_select();
            listener_animate_again();
            animate($(".animations_example__select").val());
        }
    };
    
    var listener_select = function(){
        $(".animations_example__select").change(function(){
           animate($(this).val()); 
        });
    }
    
    var listener_animate_again = function(){
        $(".animations_example__btn").click(function(){
            animate($(".animations_example__select").val());
        });
    }
    
    var animate = function(animation){
        $("#animations_example__class").text(animation).removeClass().addClass("animated " + animation).one('webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', function(){
            $(this).removeClass();
        });
    }
    
    return {
        init: init,
    };

})().init();
