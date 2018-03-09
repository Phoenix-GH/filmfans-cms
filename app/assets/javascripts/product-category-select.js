$(function() {
  var $select = $('.js-category-type');
  function createOptgroupArray($element) {
    var arr = [];
    $element.find('optgroup').each( function() {
      var categoryChilds = [];
      $(this).find('option').each(function(index, el) {
        categoryChilds.push($(el).val());
      });
      arr.push([$(this).attr('label'), categoryChilds] );
    });
    return arr;
  }
  function searchForParent(category) {
    var parent = '';
    createOptgroupArray($select).forEach(function(el) {
      if (el[1].indexOf(category.id || category) > -1) {
        parent = el[0];
      }
    });
    return parent;
  }
  function addParent(category) {
    return searchForParent(category) + ' > ' + category.text;
  }
  function diff(A, B) {
    return A.filter(function(a) {
      return B.indexOf(a) === -1;
    });
  }
  $('.js-category-type').select2({
    theme: 'bootstrap hot-select2 hot-select2-type hot-select2-multi',
    placeholder: 'Choose Category',
    multiple: true,
    width: '100%',
    templateSelection: addParent
  });
  var openVal;
  $select.on('select2:open', function() {
    openVal = $select.val() || [];
    $('body').find('.select2-results__option[aria-selected="true"]').parent().parent().addClass('active-category');
    setTimeout(function() {
      $('.select2-results__option[aria-selected="true"]').parent().parent().find('strong').addClass('active-category');
    }, 50);
  });
  var currentCategories = [];
  $select.on('select2:unselect', function() {
    var removedCat = diff(openVal, $select.val() || []).join();
    currentCategories.forEach(function(el, index) {
      if (el[1] === removedCat) {
        currentCategories.splice(index, 1);
      }
    });
  });
  $select.on('select2:select', function() {
    var selectVal = $select.val() || [];
    diff(selectVal, openVal).forEach(function(category) {
      if (currentCategories.length > 0 ) {
        currentCategories.forEach(function(el) {
          if (currentCategories.some(function(x) {
            return x[0] === searchForParent(category);
          })) {
            if (el[0] === searchForParent(category)) {
              el[1] = category;
            }
          } else {
            currentCategories.push([searchForParent(category), category]);
          }
        });
      } else {
        currentCategories.push([searchForParent(category), category]);
      }
    });

    var selectedArr = currentCategories.map(function(el) {
      return el[1];
    });
    $select.val(selectedArr);
    $select.trigger('change.select2');
  });
});
