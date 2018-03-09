$(function () {
    'use strict';

    var id = null;
    var isIndex = false;

    $(document).on('click', '.media-social-btn', function() {
      isIndex = false;
      initModal($(this));
    });

    $(document).on('click', '.popup-feed', function() {
      isIndex = true;
      initModal($(this));
    });

    function initModal($elem) {
      id = $elem.attr('data-channel');
      $('.feed-link').val($elem.attr('data-dialogfeed'));
      if($('.feed-link').val()) {
        $('#checkbox').prop('checked', true);
        $('.toggle-confirm .col-sm-9').removeClass('hide');
      }
      $('.toggle-confirm').removeClass('hide');
    }

    $('#checkbox').on('change', function() {
      if($('#checkbox').is(':checked')) {
        $('.toggle-confirm .col-sm-9').removeClass('hide')
      } else {
        $('.feed-link').val('');
        $('.toggle-confirm .col-sm-9').addClass('hide');
      }
    });

    $('.toggle-confirm .btn-cancel-channel').on('click', function() {
      $('.toggle-confirm').addClass('hide');
      $('#checkbox').prop('checked', false);
      $('.toggle-confirm .col-sm-9').addClass('hide');
    });

    $('.toggle-confirm .btn-save-channel').on('click', function(e) {
      var dialogfeed_url = $('.feed-link').val();
      var active = $('#checkbox').is(':checked');
      if(dialogfeed_url || !active) {
        var data = {
          channel_form: {
            dialogfeed_url: dialogfeed_url,
            feed_active: active
          }
        }
        if(isIndex) {
          $.ajax({
            method: "PUT",
            url: '/panel/channels/' + id + '/toggle_feed_active.js'
          })
        }
        $.ajax({
          method: "PUT",
          data: data,
          url: '/panel/channels/' + id + '/feed_settings',
          complete: function(result){
            $('.media-social-btn').attr('data-dialogfeed', $('.feed-link').val());
            $('.toggle-confirm').addClass('hide');
            $('#checkbox').prop('checked', false);
            $('.toggle-confirm .col-sm-9').addClass('hide');
            $('.feed-link').removeClass('error');
            window.location.reload();
        }});
      } else {
        $('.feed-link').addClass('error');
      }
    });
});
