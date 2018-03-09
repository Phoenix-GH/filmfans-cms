$(function() {
  var $containersDragSection = $('.containers-list');
  $containersDragSection.sortable({
    handle: '.drag'
  });
  function changeNums() {
    $('.dropdown-list__elem').each(function(index) {
      $(this).find('.dropdown-list__elem--num').text(index + 1);
      $(this).find('.collectionPosition').val(index);
    });
  }
  if ($containersDragSection.find('li').size() > 0) {
    changeNums();
  }
  $containersDragSection.on( 'sortupdate', function() {
    changeNums();
  } );
  // remove element
  $containersDragSection.on('click', '.close', function() {
    $(this).parent().parent().remove();
  });
  $('.newContainer').on('click', function(event) {
    event.preventDefault();
    changeNums();
    function formatImages(image) {
      if (!image.id) {return image.text;}

      var $image = $(
        '<span><div class="image-cropper"><img class="select-img" src="' + image.image + '" /></div>' + image.text + '</span>'
      );

      return $image;
    }
    $('.collectionIds').select2({
      theme: 'bootstrap hot-select2 hot-select2-image',
      placeholder: 'Choose Collection',
      ajax: {
        url: '/json/collections.json',
        processResults: function(data) {
          console.log(data);
          return {
            results: data
          };
        },
        cache: true
      },
      templateResult: formatImages
    });
    $containersDragSection.sortable({
      handle: '.drag'
    });
  });
});
