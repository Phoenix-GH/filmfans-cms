$(function() {
  var $select = $('.table th select');
  $select.select2({
    theme: 'bootstrap hot-select2 hot-select2-type hot-select2-table',
    width: '100%'
  });
});

$(function() {
  var $select = $('.products-vendor-filter__query-field');
  $select.select2({
    theme: 'bootstrap hot-select2 hot-select2-type',
    width: '100%'
  });
});
$(function() {
  var $select = $('.products-category-filter__query-field, .products-category-filter__create-field');
  $select.select2({
    theme: 'bootstrap hot-select2 hot-select2-type hot-select2-multi-withall',
    width: '100%'
  });
});
