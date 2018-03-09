$(function () {
    if (!$('.widget-reorder-chanels').length) {
        return;
    }

    var reorder = function () {
        var updated_orderChannel = [];
        $('.container-list-chanel .widget-chanel-order').each(function () {
            updated_orderChannel.push($(this).attr('id'));
        });
        $('.widget-reorder-chanels #ordered_channel_ids').val(updated_orderChannel.join(','));
    };
    $('.widget-reorder-chanels .container-list-chanel').sortable({
        stop: function (e, ui) {
            reorder();
        }
    });
});