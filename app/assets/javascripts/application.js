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
  $("#captcha").click(function(){
    $.ajax({
      url: '/bills/:id/captcha_image',
      type: "POST"
    });
  });
});
/*
$(document).ready(function(){
 
 /* once the user submits the form just block it until it's processed 
+  fully by the server side 
+
  $('#user-notice').on('click', function(){
    setTimeout(function(){
     App.blockUI( $('#bill_body'));
     location.reload();
     }, 200);  
    
   });
   $("#textbox").show();
 });
 */

$(document).ready(function(){
  $("#popupdiv").hide();
  $('#user-notice').on('click', function(){  
   $("#popupdiv").dialog({
        title: "Enter Captcha in Text Field",
        width: 430,
        height: 300,
        modal: true     
     });
   });
 });

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





 /*
function populateCapital(state){

 	$.ajax({
      url : 'bills_get_tin',
      type : 'GET',
      data : { 'state' : state }, 
      dataType:'json',
      
      success : function(result) {              
        console.log(result);
        // Printing the result on the label field 
        $('#capital_label').html(result['tin_number']);
      },
      
      error : function(error){
        console.log(error);
      }
	});
 }

$(document).ready(function(){
	// on change of the dropdown value populating the capital list. 
  $('#state_list').on('change', function(){
  var selected_state = $(this).val();
	console.log("Selected state value is "+ selected_state);
     populateCapital(selected_state);

  });
});

/* to update authusers table invoice_format column based on check box status */
/*
$(document).ready(function(){
  $('#bill_type').click(function() {
     var bill_type_checked = $('#bill_type').prop('checked');
     if(bill_type_checked){
     alert("you selected for the automatic Invoice number")
       
     }
    else{
     alert("you need to input value manually")
    }
    //App.blockUI( $('#bill_body'));
    // $(this).parents('form:first').submit();
  });
}); 


$(document).ready(function(){
    $("#state_of_urd").change(function(){
       $.ajax({url: '/bills/get_tin',
       data:   this.value })
        /*dataType: 'script'
       
    });
});


*/