var map, /* leaflet map */
  marker = null;

jQuery(function(){
  if(jQuery('#leaflet_map').length > 0) {
    map = L.map('leaflet_map').setView([51.505, -0.09], 13);

    L.tileLayer('http://107.20.174.7:81/osm_tiles2/{z}/{x}/{y}.png', {
      attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>, Imagery © <a href="http://cloudmade.com">CloudMade</a>',
      maxZoom: 18
    }).addTo(map);

    if(jQuery('#pob_latitude').val() != "" && jQuery('#pob_longitude').val() != "") {
      var latlng = new L.LatLng(parseFloat(jQuery('#pob_latitude').val()), parseFloat(jQuery('#pob_longitude').val()));
      marker = L.marker(latlng).addTo(map);
      map.setView(latlng, 15);
    }

    if($('.simple_form.form-horizontal').length > 0 && $('.simple_form.form-horizontal').attr('action').match(/admin\/pobs/)) {
      map.on('click', function(e) {
        pin_dropped_manually = true;

        var full_country_name = $('#pob_country').val();
        var current_city      = $('#pob_city').val();

        jQuery('#pob_latitude').val(e.latlng.lat);
        jQuery('#pob_longitude').val(e.latlng.lng);

        map.setView(e.latlng, 15);
        if (marker !== null) {
          marker.setLatLng(e.latlng);
        } else {
          marker = L.marker(e.latlng).addTo(map);
        }
        reverse_geocode_request(e.latlng.lat, e.latlng.lng);
      });
    }
  }

  // toggle banner type fields on change
  $("#banner_banner_type").change(toggle_banner_type_fields);
  // on pageload  
  toggle_banner_type_fields();

  if($('.dropdown-toggle').length > 0) {
    $('.dropdown-toggle').dropdown('.dropdown-toggle');
  }

  $('#banner_bg_color, #banner_text_color').colourPicker({
    ico: '/images/jquery.colourPicker.gif', 
    title: false
  });

  // publish/unpublish tour
  $("td.is_published input").live('click', function() {
    var id = $(this).val();
    var url = '/admin/tours/' + id + '/unpublish/'
    var auth_token = $("#auth_token").val();
    if ($(this).attr("checked")) {
      url = '/admin/tours/' + id + '/publish/'
    }
    jQuery.post(url, {id: $(this).val(), authenticity_token: auth_token});
  });
});

function delete_pob_image(i) {
  jQuery.post('/admin/pobs/remove_pob_image/'+i, function(){
    $('#pob_image_image_'+i).html('');
    $('#pob_image_input_'+i).val('');
  });
}

function toggle_pending_tours_checkboxes(state) {
  $("#pending_tours input[type=checkbox]").attr("checked", state);
  return false;
}

function toggle_banner_type_fields() {
  var banner_type = $("#banner_banner_type").val();
  if (banner_type == 'pob') {
    $("div.control-group.pob").show();
    $("div.control-group.coupon").hide();
  } else {
    $("div.control-group.coupon").show();
    $("div.control-group.pob").hide();
  }
}
function reverse_geocode_request(lat, lng) {
  jQuery.getJSON('http://geocoding.cloudmade.com/0e4c31be5b0f4424996fb1790441c7a6/geocoding/v2/find.js?object_type=road&around='+lat+','+lng+'&distance=closest&return_location=true&callback=?', function(result){
    if(result.features) {
      var address = '';
      var props = result.features[0].properties;
      var location = result.features[0].location;

      if(location) {
        if(location.city && jQuery('#pob_city').val() == "") {
          jQuery('#pob_city').removeAttr('disabled').val(location.city);
        }
        if(location.country && jQuery('#pob_country').val() == "") { 
          jQuery('#pob_country').val(location.country); 
        }
      }

      if(props['name'] || props['name:en']) {
        address = (props['name:en'] ? props['name:en'] : props['name']);
      } else if(props["addr:street"]) {
        address = props['addr:street'];
      }
      // handle "Lesi Ukrainski Blvd;Lesi Ukrainky Boulevard"
      if(address.indexOf(';') > 0) {
        address = address.split(';')[0];
      }
      
      if(address == '') {
        alert('Could not find name of this street for the city ' + jQuery('#pob_city').val() + ' in the country ' + jQuery('#pob_country').val());
      } else {
        jQuery('#pob_address').removeAttr('disabled').val(address);
      }
    }
  });
}

function zoom_to_selected_country_enable_city_disable_address() {
    var full_country_name = $('#pob_country').val();
    jQuery.getJSON("http://geocoding.cloudmade.com/0e4c31be5b0f4424996fb1790441c7a6/geocoding/v2/find.js?query=country:"+encodeURIComponent(full_country_name)+"&return_location=true&callback=?", function(result){
      if(result.features.length > 0) {
        markerLatLng = new L.LatLng(result.features[0].centroid.coordinates[0], result.features[0].centroid.coordinates[1]);
        jQuery('#pob_latitude').val(result.features[0].centroid.coordinates[0]);
        jQuery('#pob_longitude').val(result.features[0].centroid.coordinates[1]);
        map.setView(markerLatLng, 5);
      }
    });
    jQuery('#pob_city').removeAttr('disabled');
    jQuery('#pob_address').removeAttr('disabled', '');
  }

function toggle_subcategories(top_category_id) {
  // uncheck all subcats if top category was unchecked
  var top_category = $("#pob_pob_category_ids_" + top_category_id);
  jQuery('.' + top_category_id + '_subcategories').map(function() {
    var checkbox = jQuery(this);
    if (top_category.attr("checked")) {
      checkbox.attr("checked", "checked");
    } else {
      checkbox.removeAttr("checked");
    }
  });
}

function disable_top_category_if_subcats_unchecked(top_category_id) {
  // if all subcats are disabled then disable top_category
  var all_subcats_disabled = true;
  jQuery('.' + top_category_id + '_subcategories').map(function() {
    var checkBox = jQuery(this);
    if(checkBox.attr("checked")) {
      all_subcats_disabled = false;
    }
  });
  if(all_subcats_disabled) {
    jQuery('#pob_pob_category_ids_'+top_category_id).attr("checked", false);
  } else {
    jQuery('#pob_pob_category_ids_'+top_category_id).attr("checked", true);
  }
}

function check_name_validity(name, auth_token) {
  jQuery.post('/admin/clients/check_name_validity', {user_name: name, authenticity_token: auth_token});
}

function check_email_validity(email, auth_token) {
  jQuery.post('/admin/clients/check_email_validity', {email_address: email, authenticity_token: auth_token});
}

function check_password_validity(password, auth_token) {
  jQuery.post('/admin/clients/check_password_validity', {user_password: password, authenticity_token: auth_token});
}

function isNumber(n) {
  return !isNaN(parseFloat(n)) && isFinite(n);
}

closing_add_client_modal_dialog = false;

function close_add_client_modal_dialog() {
  closing_add_client_modal_dialog = true;
  jQuery('.email_address_errors').html('');
  jQuery('.user_name_errors').html('');
  jQuery('#user_name').val('');
  jQuery('#email_address').val('');
  jQuery('#add_client_modal_dialog').modal('hide');
}

function close_merge_user_modal_dialog() {
  jQuery('#merge_user_modal_dialog').modal('hide');
}

function reset_pob_filter() {
  if (location.pathname.search("search") > 0) {
    location.pathname = '/admin/pobs' 
  }
  $("form")[0].reset();
  return false;
}

var is_generating_users = false;

function generate_users_btn_onsubmit() {
  if(is_generating_users) {
    return false;
  } else {
    if(!isNumber(jQuery('#quantity').val())) {
      jQuery('.quantity_errors').html('Only numbers are allowed in Quantity field');
      return false;
    } else {
      if(parseInt(jQuery('#quantity').val()) > 10000) {
        jQuery('.quantity_errors').html('There is 10000 limit for generated users per one generation');
        return false;
      } else {
        jQuery('.quantity_errors').html('');
        is_generating_users = true;
        jQuery('.generate_users_spinner').show();
        jQuery('.generate_users_btn').addClass('disabled');
      }
    }
  }
}
