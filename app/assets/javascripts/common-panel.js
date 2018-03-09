var toggleChannelIds = function() {
  var role = $('#panel_send_admin_invitation_form_role, #panel_update_admin_form_role').val()
  if (role === 'moderator') {
    $('#channel-ids').show();
    $('#media-owner-ids').show();
  } else if (role === 'curator') {
    $('#channel-ids').hide();
    $('#media-owner-ids').show();
  } else {
    $('#channel-ids').hide();
    $('#media-owner-ids').hide();
  }
};

var mediaOwnersSelectorOptions = function(element) {
  var channel_id = $(element).val();

  $.ajax({
    url: '/json/media_owners',
    data: { channel_id: channel_id },
    success: function(results) {
      replaceSelectorContent($('.media-owner-selector'), results, true)
    }
  });
};

$(function() {
  $('#panel_send_admin_invitation_form_role, #panel_update_admin_form_role').change(function() {
    toggleChannelIds();
  });

  $('.dropdown-toggle').dropdown();

  $('.chosen-select').chosen({
    allow_single_deselect: true,
    no_results_text: 'No results matched'
  });

  $('#_media_content_type, #_home_type, #_category_id, #_store_id, #_brand, #_vendor, #_owner_id, #_role, #_country, #_social_category_id, #_genre_id').change(function() {
    this.form.submit();
  });

  $('.channel-selector').change(function() {
    mediaOwnersSelectorOptions(this)
  });

  if ($('.channel-selector').length) {
    mediaOwnersSelectorOptions($('.channel-selector'));
  }

  toggleChannelIds();
});
