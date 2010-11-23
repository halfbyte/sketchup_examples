$(function() {
  
  var log = function(string, text) {
    $('#debug')[0].value += (string + ": " + text + "\n");
  };
  
  var ifNaN = function(val, fun) {
    if(isNaN(val)) fun();
  };
  
  window.screw_thread_fill_defaults = function(innerRadius,outerRadius,length,lead,angle) {
    $('#inner_radius').val(innerRadius);
    $('#outer_radius').val(outerRadius);
    $('#length').val(length);
    $('#lead').val(lead);
    $('#angle').val(angle);
  };
  
  $('#screw_thread').submit(function(e) {
    var errors = [];
    $("#errors").html("");
    $('#screw_thread input').removeClass("error");
    
    var inner_radius = parseFloat($('#inner_radius').val());
    ifNaN(inner_radius, function() {
      $('#inner_radius').addClass('error');
      errors.push("Innenradius ist keine gültige Zahl oder fehlt");
    });        
    var outer_radius = parseFloat($('#outer_radius').val());
    ifNaN(outer_radius, function() {
      $('#outer_radius').addClass('error');
      errors.push("Aussenradius ist keine gültige Zahl oder fehlt");
    });    
    var thickness = outer_radius - inner_radius;
    if (thickness <= 0) {
      $('#outer_radius', '#inner_radius').addClass('error');
      errors.push("Aussenradius muss größer als Innenradius sein");
    }

    var lead = parseFloat($('#lead').val());
    ifNaN(lead, function() {
      $('#lead').addClass('error');
      errors.push("Steigung ist keine gültige Zahl oder fehlt");
      
    });
    var angle = parseFloat($('#angle').val()) / 180 * Math.PI;
    ifNaN(angle, function() {
      $('#angle').addClass('error');
      errors.push("Flankenwinkel ist keine gültige Zahl oder fehlt");
      
    });
    var minimumLead = Math.tan(angle/2) * thickness;
    log("minlead", minimumLead);
    if (minimumLead > (lead / 2)) {
      $('#lead', '#outer_radius', '#inner_radius', '#angle').addClass('error');
      errors.push("Die Werte ergeben kein wohlgeformtes Gewinde");
    }
    if (errors.length > 0) {
      var errorMarkup = "<ul>";
      $.each(errors, function(){
        errorMarkup += ("<li>" + this + "</li>");
      });
      errorMarkup += "</ul>";
      $("#errors").html(errorMarkup);
      return false;
    } else {
      return true;
    }
    
  });
  
  
  
  window.location = "skp:screw_thread_fill_defaults@please";
});