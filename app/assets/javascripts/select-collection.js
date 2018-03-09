$(function() {
  var $select = $('.collectionIds');
  function formatImages(image) {
    if (!image.id) {return image.text;}

    var $image = $(
      '<span><div class="image-cropper"><img class="select-img" src="' + image.image + '" /></div>' + image.text + '</span>'
    );

    return $image;
  }
  $select.select2({
    theme: 'bootstrap hot-select2 hot-select2-image',
    placeholder: 'Choose Event',
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
});
