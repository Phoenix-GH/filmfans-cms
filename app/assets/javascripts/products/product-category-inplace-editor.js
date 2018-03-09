
$(function() {
    $page = $('.products-table');
    if (!$page.length) {
        return;
    }

    $page.on('click', '.product-category-cell', function(event) {
        $categoryCell = $(event.currentTarget);
        var productId = parseInt($categoryCell.attr('data-id'));
        $('#update-product-category-model').remove();
        $.ajax({
            url: '/panel/products/' + productId + '/categories',
            dataType: 'html',
            method: 'GET',
            success: function (htmlStr) {
                var modal = $(htmlStr);
                modal.appendTo('body')
                    .modal({ backdrop: 'static', keyboard: true })
                        .one('click', '.btn-save', function(e) {
                            e.preventDefault();
                            $(e.currentTarget).attr("disabled", true);
                            updateCategories(productId,
                                $('[name="dual_listbox_product_categories[]"]').val());
                        });

                $('#update-product-category-model')
                    .find('select[name="dual_listbox_product_categories[]"]')
                    .bootstrapDualListbox({
                        nonSelectedListLabel: 'Available categories',
                        selectedListLabel: 'Selected categories',
                        selectorMinimalHeight: 200
                    });
            }
        });
    });

    function updateCategories(productId, categoryIds) {
        var $modal = $('#update-product-category-model');

        $.ajax({
            url: '/panel/products/' + productId + '/categories',
            method: 'PUT',
            data: JSON.stringify({selected_category_ids: categoryIds}),
            processData: false,
            dataType: "html",
            contentType: "application/json"
        })
        .done(function(categoriesName) {
            var $categoryCell = $('.products-table .product-category-cell[data-id="' + productId + '"]');
            $categoryCell.empty().append(categoriesName);

            var filteringCatId = $('#current_filter_category_id').val();
            if (filteringCatId != '') {
                if (categoryIds.indexOf(filteringCatId) < 0) {
                    $categoryCell.parents('.products-table-product-row').remove();
                }
            }

            $modal.modal('hide');
        })
        .fail(function(jqXHR, textStatus, errorThrown) {
            console.error(jqXHR);
            $modal.find('.alerts-container').css('display', 'block').find('.alert').append(
                'An error has occurred while saving product categories. Please try again');
        });
    }
});
