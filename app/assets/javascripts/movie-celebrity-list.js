
$(function() {
    var $page = $('.movie-celebrities-table');
    if (!$page.length) {
        return;
    }

    $page.find('#_instagram_status').change(function() {
        this.form.submit();
    });

});
