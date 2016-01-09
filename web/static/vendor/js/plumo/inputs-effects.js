var Inputs_Effect = (function () {

    var selector = "input[type='text'],input[type='email'],input[type='password'], textarea";

    var init = function(){
        
        if( $(selector).length ){
            wrap();
            focus_listener();
        }
    };
    
    var wrap = function(){
        $(selector).each(function(){
            if(!($(this).closest(".form-group").hasClass("has-success") || $(this).closest(".form-group").hasClass("has-warning") || $(this).closest(".form-group").hasClass("has-error")))
                $(this).wrap('<div class="input-wrapper"/>');    
        });
        
    }
    
    var focus_listener = function(){
        $(selector).focus(function(){
            $(".input-wrapper").removeClass("focus");
            $(this).closest(".input-wrapper").addClass("focus");
        });
        
        $(selector).focusout(function(){
            $(".input-wrapper").removeClass("focus");
        });
    }
    
    return {
        init: init,
    };

})().init();
