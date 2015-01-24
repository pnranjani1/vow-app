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
//= require jquery_ujs
//= require turbolinks
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
//= require jquery.blockUI
//= jquery.flexslider.min
//= require jquery.min
//= require sliderscript
//= require_tree .

$(document).ready(function(){
  
/* once the user submits the form just block it until it's processed 
  fully by the server side 
*/
  $('#user-notice').on('click', function(){
    App.blockUI( $('.portlet-content'));
  });
  

  
  bindItemFields();
  
  $(document).on('click', '#line_items_fields_blueprint', function(){
    bindItemFields();
  });
});

  $(document).on('nested:fieldAdded', function(event){
      bindItemFields();
    calculateTotal();
      console.log("line 83");
  });

 function calculateTotal(){
   var result = $('div.fields').html();
  console.log(result);
   var quantity = parseInt($('#quantity').val());
   var unit_price = parseInt($('#unit_price').val());
   if(!(isNaN(quantity) || isNaN(unit_price))){
     var total_result = quantity * unit_price
     console.log("total result is " + total_result);
     $('#total_price').val(total_result);
   }
   else{
     $('#total_price').val(0);
   }
 }

 function bindItemFields(){
   console.log("Yes Just bound the things with you");
  $('div.fields').on('keyup','#quantity', function(e) {
    console.log("hitting the spot"+ e);
    
    
    calculateTotal();
  });
  
  $('div.fields').on('keyup', '#unit_price', function(e){
    console.log("hitting the spot"+ e);
    calculateTotal();
  }); 
 }


 
var App = function(){
      return {
        blockUI: function(el){
        el.block({
        message: '',
        css: {backgroundColor: 'none'},
        overlayCSS: {
        backgroundColor:'#FFFFFF',
        //You will find loader image, in your assets/images folder.
        backgroundImage: "url('/assets/loader.gif')",
        backgroundRepeat: 'no-repeat',
        backgroundPosition: 'center',
        opacity: 0.67
      }
    });
  },unBlockUI: function(el){
    el.unblock();
  }
  }
  }();