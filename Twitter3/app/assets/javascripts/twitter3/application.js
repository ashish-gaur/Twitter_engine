// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .


$(document).ready(function(){

    $.fn.hide_elapsed_time = function(){
        this.mouseenter(function(){
            var elapsed_id = $(this).attr('id')
            elapsed_id = '#' + elapsed_id
            var full_id = '#' + 'time_full' + elapsed_id[elapsed_id.length - 1]
            $(full_id).show()
            $(elapsed_id).hide()
        });
    }

    $.fn.show_full_time = function(){
        this.mouseleave(function(){
            $(".time_elapsed").show()
            $(".time_full").hide()
        });
    }

    $.fn.validate_signup_format = function(){
        this.validate({
            rules:{
                "user[username]": {required: true},
                "user[email]": {required: true, email: true},
                "user[password]": {required: true, minlength: 6},
                "user[password_confirmation]": {required: true, equalTo: "#user_password"}
            },
            messages:{
                "user[username]": "Name field cannot be blank",
                "user[email]": "Email cannot be blank and must be vaild",
                "user[password]": "Password field cannot be blank",
                "user[password_confirmation]": "Password must match"
            }
        })
    }
    $.fn.validate_login = function(){
        this.validate({
            rules:{
                username_or_email:{required:true},
                login_password:{required:true, minlength:6}
            },

            messages: {
                username_or_email: 'Please specify your name',
                login_password: 'Password cannot be less than 6'
            }
        });
    }

    $.fn.validate_tweet_content = function(){
        this.validate({
            rules:{
                tweet:{required:true, minlength:20, maxlength:100}
            },

            messages:{
                tweet: 'Tweet must be atleast 20 characters and atmost 100 characters'
            }
        })
    }

    jQuery.fn.exists = function(){return this.length > 0;}

    $(function(){
        $("#select_user").autocomplete({
            appendTo: "#options",
            selectFirst: true,
            minLength: 3,
            source: function( request, response){
                $.ajax({
                    url: 'sessions.json',
                    data: request,
                    success: function( data ){
                        response(data);
                        if (data.length == 0){
                            if ($("#error_message").exists()){
//                                $("#error_message").text("No match found")
                            }
                            else{
                                var err = document.createElement('label')
                                err.innerHTML = "No match found"
                                err.id = "error_message"
                                $("#search_div").append(err)
                            }
                        }
                    },
                    error: function(){
                        response ([]);
                    }
                });
            },
            focus: function(event, ui){
                $("#select_user").val(ui.item.username);
                return false;
            },

            select: function(event, ui){
                $("#select_user").val(ui.item.username);
                $("#link_user_id").val(ui.item.id);
                if ($("#follow_link").exists()){
                    $("#follow_link").href("http://localhost:3000/follow?id=" + ui.item.id)
                }
                else{
                    var url = "http://localhost:3000/follow?id="
                    url += ui.item.id

                    var link = document.createElement('a')
                    link.innerHTML = "request"
                    link.href = url
                    link.id = 'follow_link'
                    $("#search_div").append(link)

                }
                return false;
            },

            messages: {
                noResults: '',
                results: function() {}
            }
        }).data("ui-autocomplete")._renderItem =  function(ul, item){
            if ($("#follow_link").exists()){
                $("#follow_link").remove()
            }
            if ($("#error_message").exists()){
                $("#error_message").remove()
            }
//            $("#error_message").empty()
            return $("<li></li>")
                .data( "ui-autocomplete-item", item )
                .append("<a>" + item.username + "</a>")
                .appendTo( ul );
        };
    });

//    $("#select_user").on('input', function(){
//        if ($("#follow_link").exists()){
//            $("#follow_link").remove()
//        }
//        if ($("#error_message").exists()){
//            $("#error_message").remove()
//        }
//    });

//    $(function(){
//        $("#follow_link").onclick(function(){
//            var url = "http://localhost:3000/follow?id="
//            url += $("#link_user_id").getAttribute("id")
//            this.attr("href", url)
//        });
//    });
//     $(function(){
//         $("#select_person").autocomplete({
//             minLength: 3,
//             source: 'sessions.json'
//         });
//     });


//    $("input#term").autocomplete({
//        source: "<%= search_path %>",
//        minLength:3,
//        delay:500
//    });

    $(".time_full").hide();
    $(".time_elapsed").hide_elapsed_time()
    $(".time_full").show_full_time()
    $("#signupform").validate_signup_format()
    $("#loginform").validate_login()
    $("#tweet_content").validate_tweet_content()
    $("#editform").validate_signup_format()
//    $("#select_person").autocomplete_search_box()

});

