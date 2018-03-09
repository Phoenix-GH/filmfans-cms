
$(function() {
    var $page = $('.benchmark-detail');
    if (!$page.length) {
        return;
    }

    $page.on('change', 'select[name="benchmark_form[review]"]', function (e) {
        e.preventDefault();
        var option = $(this).find('option:selected');
        if (!option.length) {
            return;
        }

        var $cbxCate = $page.find('#benchmark_form_retrained_category');
        if (option.val() == 'PRS_W_CATE') {
            $cbxCate.removeAttr('disabled');
        } else {
            $cbxCate.find("option[selected='selected']").removeAttr('selected');
            $cbxCate.find("option[value='']").attr('selected','selected');
            $cbxCate.attr('disabled', 'disabled');
        }
    });
});
