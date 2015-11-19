// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//

//= require jquery
//= require jquery.turbolinks
//= require jquery_ujs

//= require nested_form
//= require bootstrap-datepicker
//= require bootstrap.min
//= require camera
//= require jquery.carouFredSel-6.1.0-packed
//= require jquery.easing.1.3
//= require jquery.nicescroll.min
//= require jquery-1.10.1.min
//= require jquery-migrate-1.2.1.min
//= require select2
//= require target-admin
//= require touchTouch.jquery
//= require bootstrap-fileupload
//= require bootstrap-datepicker
//= require logoslider
//= jquery.flexslider.min
//= require jquery.min
//= require sliderscript
//= require jquery.blockUI
//= require_tree .

var App = function(){
  return {
    blockUI: function(el){
      el.block({
        message: 'Please wait...Esugam Number generation is in progress',
        css: {backgroundColor: 'none'},
        overlayCSS: {
          backgroundColor:'#FFFFFF',
         /* backgroundImage: "url('/assets/loader.gif')", */
          backgroundRepeat: 'no-repeat',
          backgroundPosition: 'center',
          opacity: 0.67
          /* timeout: 3000 */
        }
      });
    },
    unBlockUI: function(el){
      el.unblock();
    }
  }
}();


$(document).ready(function(){
 
 /* once the user submits the form just block it until it's processed 
+  fully by the server side  */
  $('#user-notice').on('click', function(){
       App.blockUI( $('#bill_body'));
    });
    });

/*
  
 $(document).ready(function(){
  $("#user-notice").on("click",function(event) {

      // Show Progress Indicator
      $(".ajax-progress").show();
});
}); 
  
  

/*
$(document).ready(function(){
  $("#loading-image").hide();
   $("#user-notice").click(function(){
      $("#loading-image").show();
   });
});




$(document).ready(function(){
   $('#user-notice').click(function() {
     $('.loading-image').show();
    });
});
 */

/* buttons: {
       Close: function() {
         $(this).dialog('close');
       }
      } */

$(document).ready(function() {
  $('.has-tooltip').tooltip();
});

$(document).ready(function() {
 $('[data-toggle="tooltip"]').tooltip()
 })

/* show text based on value from drop down */


$(document).ready(function(){
  $('#drop-down').change(function() {
    var a = $(this).find(":selected").text();
   if (a == "Other" || a == "Others" || a== "other" || a == "others"){
    $("div #text-box").show();
   }
    else
    {
      $("div #text-box").hide();
    }  
    
  });
});

  $(document).ready(function(){
    $('#item_add').on("click", function(){
      console.log("okay");
    });
  });

 $(document).ready(function(){
   $("#sub-user").change(function(){
     $(this).parent('form').submit();
   }); 
 });