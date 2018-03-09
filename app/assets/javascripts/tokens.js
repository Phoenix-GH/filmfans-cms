$(function() {
  var defaultConfig = {
    preventDuplicates: true,
    theme: 'facebook',
    queryParam: 'search',
    noResultsText: 'No results.',
    minChars: '1',
    tokenFormatter: function(item) {
      return '<li><img src="' + item.image + '"></img><br><p>' + item.name + '</p></li>';
    },
    resultsFormatter: function(item) {
      return '<li><img src="' + item.thumb + '"></img>' + item.name + '</li>';
    }
  };

  $('.similar_products').tokenInput('/json/products.json', $.extend(
    {},
    defaultConfig, {
      prePopulate: $('.similar_products').data('pre')
    }
  ));

  $('.home_contents').tokenInput('/json/home_contents.json', $.extend(
    {},
    defaultConfig, {
      tokenValue: 'token',
      prePopulate: $('.home_contents').data('pre'),
      tokenFormatter: function(item) {
        return '<p>' + item.name+ '</p>';
      },
      resultsFormatter: function(item) {
        return '<li>' + item.name + '</li>';
      }
    }
  ));

  $('.product_ids').tokenInput('/json/products.json', $.extend(
    {},
    defaultConfig, {
      prePopulate: $('.product_ids').data('pre')
    }
  ));

  // $('.collection_ids').tokenInput('/json/collections.json', $.extend(
  //   {},
  //   defaultConfig, {
  //     prePopulate: $('.collection_ids').data('pre'),
  //     tokenFormatter: function(item) {
  //       return '<p>' + item.name+ '</p>';
  //     },
  //     resultsFormatter: function(item) {
  //       return '<li>' + item.name + '</li>';
  //     }
  //   }
  // ));


  $(document).on('click', '.taggd-item-hover.show > input', function() {
    $('.taggd-item-hover.show > input').tokenInput('/json/products.json', $.extend(
      {},
      defaultConfig, {
        tokenLimit: 1,
        tokenValue: 'name'
      }
    ));
    $('input#token-input-').focus();
  });
});
