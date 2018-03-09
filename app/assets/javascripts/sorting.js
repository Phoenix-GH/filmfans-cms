set_positions = function() {
  $('ul.sortable li').each(function(i) {
    $(this).attr("data-pos", i+1);
  });
};

reorder = function(url) {
  var updated_order = [];
  set_positions();

  $('ul.sortable li').each(function(i) {
    updated_order.push({ id: $(this).data("id"), position: i+1 });
  });

  $.ajax({
    method: "put",
    url: url,
    data: { order: updated_order }
  });
};

$(function() {
  set_positions();

  $('.products-sortable').sortable().bind('sortupdate', function(e, ui) {
    url = '/panel/products_containers/' + app.vars.productsContainerId + '/sort';
    reorder(url);
  });

  $('.collection-sortable').sortable().bind('sortupdate', function(e, ui) {
    url = '/panel/collections/' + app.vars.collectionId + '/sort';
    reorder(url);
  });

  $('.home-sortable').sortable().bind('sortupdate', function(e, ui) {
    url = '/panel/homes/' + app.vars.homeId + '/sort';
    reorder(url);
  });

  $('.collections-container-sortable').sortable().bind('sortupdate', function(e, ui) {
    url = '/panel/collections_containers/' + app.vars.collectionsContainerId + '/sort';
    reorder(url);
  });
});
