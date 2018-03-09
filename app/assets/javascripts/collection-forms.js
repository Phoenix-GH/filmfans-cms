$(function() {
  $('body').on('click', '.remove_link', function() {
    $(this).prev('input[type=hidden]').val('true');
    $(this).closest('.content-container').hide();
    var $container = $($(this).data('target-container'));
    $container.trigger('member:removed');
  });

  $('.add_link').click(function () {
    var $this = $(this);
    var association = $(this).data('association');
    var content = $(this).data('content');
    var newId = new Date().getTime();
    var regexp = new RegExp('new_' + association, 'g');
    if ($this.data('target-container')) {
      $(content.replace(regexp, newId)).appendTo($($this.data('target-container'))).trigger('collection:newElement');
    }
    else {
      $(content.replace(regexp, newId)).insertBefore($(this)).trigger('collection:newElement');
    }
    var $container = $($(this).data('target-container'));
    $container.trigger('member:added', { id: newId });
  });

  $('.container-type-selector').each(function() {
    replaceCollectionInSelector(this);
  });

  $(document).on('change', '.container-type-selector', function() {
    replaceCollectionInSelector(this);
  });
});

var replaceCollectionInSelector = function(that) {
  var ProductsContainersCollection = app.vars.ProductsContainersCollection;
  var MediaContainersCollection = app.vars.MediaContainersCollection;
  var ComboContainersCollection = app.vars.ComboContainersCollection;
  var selectList = $(that).parents('.content-container').find('.container-name-selector');

  if (that.value === 'ProductsContainer') {
    replaceSelectorContent(selectList, ProductsContainersCollection);
  } else if (that.value === 'MediaContainer') {
    replaceSelectorContent(selectList, MediaContainersCollection);
  } else if (that.value === 'ComboContainer') {
    replaceSelectorContent(selectList, ComboContainersCollection);
  }
};

var replaceSelectorContent = function(selectList, collection, with_blank) {
  selectList.empty();
  if(with_blank) {
    selectList.append(new Option());
  }

  for (var i = 0, l = collection.length; i < l; i++) {
    selectList.append(new Option(collection[i].name, collection[i].id));
  }
  if(selectList.data('selectedId')) {
    selectList.val(selectList.data('selectedId'));
  }
};
