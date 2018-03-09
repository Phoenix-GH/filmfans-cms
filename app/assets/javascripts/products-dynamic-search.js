$(function() {
  if ($('.products-table').length) {
    var $brand_search = $('.brand-search').find('.search').find('input'),
      $name_search = $('.name-search').find('.search').find('input'),
      $category_id = $('#_category_id'),
      $direction = $('#_direction'),
      $vendor = $('#_vendor'),
      $sort = $('#_sort');

    $(document).on('input', [$brand_search, $name_search], function (event) {
      updateSortableLinks(event.target);
      var data = {
        brand_search: $brand_search.val(),
        search: $name_search.val(),
        category_id: $category_id.val(),
        direction: $direction.val(),
        vendor: $vendor.val(),
        sort: $sort.val()
      };
      $.ajax({
        url: "/panel/products/table",
        data: data,
        type: "GET"
      }).done(function (data) {
        $('.table-responsive').find('tbody').replaceWith(data)
      })
    });
  }
});

var updateSortableLinks = function(input) {
  var value       = $(input).val(),
      id          = input.id,
      $links      = $('.sortable'),
      filter      = (id == '_search') ? 'search' : 'brand_search',
      matchFilter = '&' + filter + '=.*?(?=(&|$))',
      regexp      = new RegExp(matchFilter, 'g'),
      newFilter   = '&' + filter + '=' + value;

  $.each($links, function(i, $link) {
    var href = $link.href;

    if (href.match(regexp)) {
      var newHref = href.replace(regexp, newFilter);
    } else {
      var newHref = href + newFilter;
    }

    $link.href = newHref;
  });
};