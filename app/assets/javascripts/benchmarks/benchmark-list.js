
$(function() {
    var $page = $('.benchmark-list');
    if (!$page.length) {
        return;
    }

    $page.find('#_review, #_sent_to_ma').change(function() {
        this.form.submit();
    });

    $page.on('click', '.technical-details-title', function(e) {
        $target = $(e.currentTarget);
        $target.css('display', 'none');
        $target.parent().find('.technical-details-details').css('display', 'block');
    });
});
