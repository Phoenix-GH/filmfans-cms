$(function() {
    var $container = $('.association-list');
    var $dragSection = $container.find('.dropdown-list');
    $dragSection.sortable({
        handle: '.drag'
    });
    function changeNums() {
        $dragSection.find('.dropdown-list__elem').each(function(index) {
            $(this).find('.dropdown-list__elem--num').text(index + 1);
            $(this).find('.item-position').val(index);
        });
    }
    if ($dragSection.find('li').size() > 0) {
        changeNums();
    }
    $dragSection.on('sortupdate', function() {
        changeNums();
    } );
    $dragSection.on('click', '.close', function() {
        $(this).parent().parent().remove();
    });
    $container.on('click', '.btn-add-item', function(event) {
        event.preventDefault();
        changeNums();
        function formatImages(image) {
            if (!image.id) {return image.text;}

            var $image = $(
                '<span><div class="image-cropper"><img class="select-img" src="' + image.image + '" /></div>' + image.text + '</span>'
            );

            return $image;
        }

        $container.find('.available-items').select2({
            theme: 'bootstrap hot-select2 hot-select2-image',
            placeholder: 'Choose ' + $container.data('association'),
            ajax: {
                url: $container.data('fetch-url'),

                data: function (params) {
                  return {
                    search: params.term,
                    page: params.page
                  };
                },

                processResults: function(data) {
                    return {
                        results: data
                    };
                },
                cache: true
            },
            templateResult: formatImages
        });
        $dragSection.sortable({
            handle: '.drag'
        });
    });
});
