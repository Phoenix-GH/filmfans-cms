$(function () {

  var reorder = function () {
    var updated_orders = [];
    $('.widget-reorder .container-list .widget-order, .sorted_table tr').each(function () {
      updated_orders.push($(this).attr('id'));
    });
    $('.widget-reorder input[name=ordered_ids], #social_account_followings_sort_input').val(updated_orders.join(','));
  };

  $('.sorted_table').sortable({
    containerSelector: 'table',
    itemPath: '> tbody',
    itemSelector: 'tr',
    placeholder: '<tr class="placeholder"/>',
    stop: function () {
      reorder();
    }
  });

  if (!$('.widget-reorder').length) {
    return;
  }

  $('.widget-reorder .container-list').sortable({
    stop: function () {
      reorder();
    }
  });
});