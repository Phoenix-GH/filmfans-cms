$(function () {
    var $classifier = $('.classifier-in-edit');
    if (!$classifier.length) {
        return;
    }

    var totalSlides = $classifier.data('totalSlide');
    var SLIDE_TO_SHOW = 3;

    $classifier.slick({
        arrows: true,
        infinite: false,
        slidesToShow: SLIDE_TO_SHOW
    });

    var scrollTo = $classifier.data('current-slide-index');
    if (!scrollTo) {
        return;
    }

    scrollTo = scrollTo ? scrollTo + 1 : 1;
    scrollTo = (scrollTo > totalSlides - 2) ? totalSlides - 2 : scrollTo;
    $classifier.slick('slickGoTo', scrollTo - 1);
});

$(function() {
    var $classifierPreview = $('.classifier-preview');
    if (!$classifierPreview.length) {
        return;
    }

    var SLIDE_TO_SHOW = 3;

    $classifierPreview.slick({
        arrows: true,
        infinite: false,
        slidesToShow: SLIDE_TO_SHOW
    });

    $classifierPreview.on('click', '.classifier-item', function(e) {
        e.preventDefault();
        // Click on each item
        var itemSel = '[data-benchmark-id=' + $(this).data('benchmark-id') + ']';
        $('.bbprs' + itemSel + ' .classifier-item, ' + '.ulabprs' + itemSel + ' .classifier-item').removeClass('selected');
        $('.bbprs' + itemSel + ' .bbprs-preview-details, ' + '.ulabprs' + itemSel + ' .bbprs-preview-details').hide();
        $(this).addClass('selected');

        var crop_id = $(this).data('crop-id');
        var $topProducts = $('.bbprs-preview-details[data-crop-id=' + crop_id + ']');
        var $productContainer = $topProducts.find('.form-group');

        $topProducts.show();

        if ($topProducts.find('.result.product-detail-trigger').length === 0) {
            // No result found
            $productContainer.html('<span class="spinner"></span>');
            $.ajax({
                url: '/api/v1/snapped_products/sub_results/' + crop_id,
                method: 'GET'
            }).success(function(response) {
                var products = response.man || response.woman;
                var topProducts = _.take(products, 12);
                if (topProducts.length === 0) {
                    $productContainer.html('No product returned');
                } else {
                    $topProducts.find('.statistics').html('Top products: ');
                    var rowMax = 6;
                    var chunkedProducts = _.groupBy(topProducts, function(element, index){
                        return Math.floor(index/rowMax);
                    });
                    var chunkedProducts = _.toArray(chunkedProducts);

                    _.each(chunkedProducts, function(row) {
                        var productTemplate = ['<div class="row">'];
                        _.each(row, function(product) {
                            var productImageUrl = product.small_image || product.medium_image || product.image;
                            productTemplate.push(
                                '<div class="col-xs-6 col-sm-4 col-md-3 col-lg-2">',
                                    '<div class="result product-detail-trigger" data-id="' + product.id + '">',
                                        '<label class="result__content benchmark-tab">',
                                            '<div class="result__content__image">',
                                                '<img src="' + productImageUrl + '" alt="' + product.name + '"/>',
                                            '</div>',
                                        '</label>',
                                    '</div>',
                                '</div>'
                            );
                        });
                        productTemplate.push('</div>');
                        $productContainer.append(productTemplate.join(''));
                    });
                }
            }).fail(function() {
                $productContainer.html('Fail to get products. Please try again');
            }).done(function() {
                $topProducts.find('.spinner').remove();
            })
        }
    });
});