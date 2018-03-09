
$(function() {
    $page = $('.product-detail-support');
    if (!$page.length) {
        return;
    }

    $page.on('click', '.product-detail-trigger', function(event) {
        var productId = parseInt($(event.currentTarget).attr('data-id'));
        $('#view-product-details-modal').remove();
        $.ajax({
            url: '/panel/products/' + productId + '/product_detail',
            dataType: 'html',
            method: 'GET',
            success: function (htmlStr) {
                var modal = $(htmlStr);
                modal.appendTo('body')
                    .modal({ backdrop: 'static', keyboard: true });
            }
        });
    });
});
