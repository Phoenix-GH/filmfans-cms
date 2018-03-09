$(function () {
    if (!$('.media-owner-trending').length) {
        return;
    }

    var toggleDisplaySelect = function(owner) {
        if (owner && owner.indexOf('MediaOwner') > -1) {
            $('.manual_post_form_display_option').show();
        } else {
            $('.manual_post_form_display_option').hide();
        }
    };

    toggleDisplaySelect($('.chosen-select.owner-options').val());

    $('.chosen-select.owner-options').on('change', function() {
        toggleDisplaySelect($('.chosen-select.owner-options').val());
    });
});