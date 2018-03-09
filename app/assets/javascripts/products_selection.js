$(function(){
    window.PRODUCT_JSON_PRODUCTS_LOADED_EVENT = 'on-product-json-search-loaded';
    var SCROLL_ANIMATION_TIME = 50;
    var MAX_DISPLAY_ITEMS = 100;
    var DISTANCE_FROM_EDGE_TO_START_PAGING = 140;
    var ITEMS_PER_PAGE = 50;
    var VERTICAL_SCROLL_BAR_HEIGHT = 80;

    var currentPage = 1;
    var isLoadingOnScroll = false;
    var allowSearchOnScrollDown = true;
    var allowSearchOnScrollUp = false;
    var loadedPage = 0;

    var current_id = null;
    var found_products = [];
    window.linked_products = [];
    window.selected_products= [];
    var $productSearchResultContainer = $('.products-search__results');

    Handlebars.registerHelper('isChecked', function (selected) {
        return $productSearchResultContainer.hasClass('no_checkbox_selection') ? false : (selected ? 'checked' : '');
    });
    $('.products-search__query-field').on('keypress', function (event) {
        if (event.keyCode === 10 || event.keyCode === 13) {
            event.preventDefault();
            event.stopPropagation();
        }
    });

    $('.products-search__query-field').keyup(_.debounce(changeFilter, 1000));
    $('.products-category-filter__query-field').change(changeFilter);
    $('.products-vendor-filter__query-field').change(changeFilter);

    $productSearchResultContainer.scroll(function() {
        var scrollTopPos = $(this).scrollTop();
        var elmInnerHeight = $(this).innerHeight();
        var maxScrollDown = $(this)[0].scrollHeight;

        if (scrollTopPos + elmInnerHeight <= maxScrollDown - DISTANCE_FROM_EDGE_TO_START_PAGING) {
            allowSearchOnScrollDown = true;
        }

        if (scrollTopPos + elmInnerHeight > (maxScrollDown - DISTANCE_FROM_EDGE_TO_START_PAGING) && allowSearchOnScrollDown && !isLoadingOnScroll) {
            currentPage++;
            isLoadingOnScroll = true;
            allowSearchOnScrollDown = false;
            allowSearchOnScrollUp = true;

            // Only allow to load the page that is not yet loaded
            if (currentPage > loadedPage) {
                getProductFromServer();
            } else {
                renderFoundProducts();
                isLoadingOnScroll = false;
            }
        }

        if (scrollTopPos >= DISTANCE_FROM_EDGE_TO_START_PAGING - VERTICAL_SCROLL_BAR_HEIGHT) {
            allowSearchOnScrollUp = true;
        }

        if (scrollTopPos < (DISTANCE_FROM_EDGE_TO_START_PAGING - VERTICAL_SCROLL_BAR_HEIGHT) && allowSearchOnScrollUp && !isLoadingOnScroll) {
            isLoadingOnScroll = true;
            allowSearchOnScrollDown = true;
            allowSearchOnScrollUp = false;

            /*
            *
            * Do not allow to re-display the page that is not exist
            * And only allow to re-display the page that has already been loaded
            *
            * */
            if (currentPage > 2) {
                currentPage--;
                // filterAndSearchProducts();
                renderPrevHiddenProducts();
            }
            isLoadingOnScroll = false;
        }
    });

    $(document).on('change', '.js-result-checkbox', function(e){
        var $elem = $(this);
        var params = {
            id: $elem.data('id'),
            name: $elem.data('name'),
            brand: $elem.data('brand'),
            price: $elem.data('price'),
            image: $elem.data('image'),
            vendor: $elem.data('vendor'),
            vendor_url: $elem.data('vendor-url'),
            available: $elem.data('available')
        };

        if ($elem.is(':checked')){
            addProductToCollection(params);
        } else {
            removeProductFromCollection(params.id);
        }
    });

    $(document).on('click', '.products-search__selection li', function(e) {
        if ($(e.currentTarget).hasClass('no-product-detail')) {
            return;
        }
        $('#popupProduct').removeClass('hide');
        //Set information product
        current_id = $(this).attr('data-id');
        for(var i = 0; i < selected_products.length; i++) {
          if(selected_products[i].id == current_id || selected_products[i].position == current_id) {
            $('#popupProduct .product-image').css('background-image', 'url(' + selected_products[i].image + ')');
            $('#popupProduct .product-name').text(selected_products[i].name || '');

            var vendorUrlPrefix = '';
            if (selected_products[i].vendor_url.indexOf('http') !== 0) {
              vendorUrlPrefix = 'http://';
            }
            $('#popupProduct .product-link a').attr('href', selected_products[i].vendor_url ? vendorUrlPrefix + selected_products[i].vendor_url : '');
            $('#popupProduct .product-link a').text(selected_products[i].vendor_url ? (selected_products[i].vendor ? selected_products[i].vendor : 'Product Link') : '');
            $('#popupProduct .product-brand').text(selected_products[i].brand || '');
            $('#popupProduct .product-price').text(selected_products[i].price || '');
          }
        }
    });

    $(document).on('click', '.products-search__selection li i', function(e) {
        e.stopPropagation();
        current_id = $(this).parent().attr('data-id');
        if (current_id) {
            removeProductFromCollection(current_id);
        }
    });

    $(document).on('click', '#popupProduct .btn-cancel-container, #popupProduct .btn-close-container', function(e) {
        $('#popupProduct').addClass('hide');
    });

    $(document).on('click', '#popupProduct .btn-remove-container', function(e) {
        removeProductFromCollection(current_id);
        $('#popupProduct').addClass('hide');
        current_id = null;
    });

    function getProductFromServer() {
        var keyword = $('.products-search__query-field').val();
        $.get('/json/products.json?available=true&per=' + ITEMS_PER_PAGE + '&page=' + currentPage + '&search=' + keyword
            +'&[category_id]='+$('.products-category-filter__query-field').val()
            +'&[vendor]='+$('.products-vendor-filter__query-field').val(), function(data) {
                if (keyword != $('.products-search__query-field').val()) {
                    console.debug(keyword + ':' + $('.products-search__query-field').val());
                    return;
                }

                if (data.length === 0) {
                    currentPage--;
                    isLoadingOnScroll = false;
                    return;
                }
                loadedPage++;
                for (var i = 0; i < data.length; i++) {
                    data[i].uuIndex = found_products.length;
                    found_products.push(data[i]);
                }
                renderFoundProducts();
        });
    }

    function renderSelectedProducts(){
        var template = HandlebarsTemplates['products/selected_product'];
        var $container = $('.js-product-selection');
        var products = _(selected_products).sortBy('position');
        $container.html('');
        if(products.length > 0){
          $('.js-product-selection').removeClass('filled');
          _(products).each(function(product){
             $container.append(template(product))
          });

        } else {
          $('.js-product-selection').addClass('filled');
        }

        initSortable();
        $('#products_container_form_product_ids').val(_(products).pluck('id').join());
        $('.js-selected-products-counter').html('('+selected_products.length+')');
    }

    function renderFoundProducts(){
        // Calculate the start and end index of products
        var startProduct, endProduct, removeFrom, removeTo, appendProducts;
        startProduct = (currentPage - 1) * ITEMS_PER_PAGE;
        endProduct = currentPage * ITEMS_PER_PAGE;
        removeFrom = 0;
        removeTo = ITEMS_PER_PAGE;

        // Remove the top most not seeable items from the container
        if ($productSearchResultContainer.children().length >= MAX_DISPLAY_ITEMS) {
            $productSearchResultContainer.children().slice(removeFrom, removeTo).remove();
        }

        appendProducts = found_products.slice(startProduct, endProduct);

        /*
        *
        * The timeout to ensure scrollbar position is change after removing items
        * So it will automatically re-adjust after adding new items
        *
        * */
        setTimeout(function() {
            // Append a new seenable products to the container
            $.each(appendProducts, function(idx, product){
                product = addSelectionStatus(product);
                $productSearchResultContainer.append(HandlebarsTemplates['products/search_result'](product));
            });
            isLoadingOnScroll = false;
            $(document).trigger(window.PRODUCT_JSON_PRODUCTS_LOADED_EVENT)
        }, SCROLL_ANIMATION_TIME);
    }

    function renderPrevHiddenProducts() {
        var prevPage = currentPage - 1;
        var startProduct = (prevPage - 1) * ITEMS_PER_PAGE;
        var endProduct = (prevPage) * ITEMS_PER_PAGE;
        var removeFrom = ITEMS_PER_PAGE;
        var removeTo = $productSearchResultContainer.children().length;

        // Remove the bottom most items from the container
        $productSearchResultContainer.children().slice(removeFrom, removeTo).remove();

        var appendProducts = found_products.slice(startProduct, endProduct).reverse();

        // Append a new seenable products to the container
        $.each(appendProducts, function(idx, product){
            product = addSelectionStatus(product);
            $productSearchResultContainer.prepend(HandlebarsTemplates['products/search_result'](product));
        });

        $productSearchResultContainer.scrollTop($productSearchResultContainer.scrollTop() + $productSearchResultContainer.innerHeight() * 2);

        $(document).trigger(window.PRODUCT_JSON_PRODUCTS_LOADED_EVENT)
        // console.log('Current page: ' + currentPage + '. Start: ' + startProduct + '. End: ' + endProduct + '. Total: ' + found_products.length + '. Append: ' + appendProducts.length + '. Dom count after: ' + $('.products-search__results').children().length);
    }

    function addProductToCollection(product){
        selected_products.push(product);
        renderSelectedProducts();
        updateHiddenFields();
    }

    function removeProductFromCollection(product_id){
        delete [product_id];
        var index = _(selected_products).findIndex(function(product){
            return product.id == product_id;
        });

        if (index > -1) {
            // Remove selection from search result
            $('.js-result-checkbox[data-id=' + product_id + ']').attr('checked', false);
            selected_products.splice(index, 1);
        }

        renderSelectedProducts();
        updateHiddenFields();
    }

    function addSelectionStatus(product){
        product['selected'] = isProductSelected(product);
        return product;
    }

    function isProductSelected(product){
        return _(selected_products).findIndex(function(_product){
            return _product.id == product.id;
        }) > -1;
    }

    function initSortable(){
        $('.js-product-selection').sortable().bind('sortupdate', function(e, ui) {
            updateHiddenFields();
        });
    }

    function updateHiddenFields(){
        $('.linked-products-collection .linked-product').remove();
        $('.js-product-selection li').each(function(idx, product){
            //$('.fields').append(orderHiddenField(idx, $(product).data('id'), idx + 1))
            $('.linked-products-collection').append(linkedProductHiddenField(idx, $(product).data('id'), idx + 1))
        });
    }

    function linkedProductHiddenField(idx, product_id, position, destroy){
        var list_index =  Date.now() + '' + Math.floor((Math.random() * 10000));
        destroy = destroy == undefined ? false : destroy;
        var regexp = new RegExp('new_linked_product', 'g');
        var $template = $($('.linked-products-collection').data('template').replace(regexp, list_index));
        $template.find("[name*='product_id']").attr('value', product_id);
        $template.find("[name*='product_to_id']").attr('value', product_id);
        $template.find("[name*='position']").attr('value', position);
        $template.find("[name*='_destroy']").attr('value', destroy);

        return $template;
    }

    function populateLinkedProducts(callback){
        var $linked_products = $('.linked-products-collection .linked-product');
        var _linked_products = [];
        var product_ids = [];
        var positions = _($linked_products).reduce(function(memo, linked_product){
            var product_id = parseInt($(linked_product).find("[name*='product_id']").val());
            var product_to_id = parseInt($(linked_product).find("[name*='product_to_id']").val());
            var position = parseInt($(linked_product).find("[name*='position']").val());
            memo[product_id] = position;
            if (!isNaN(product_id)) {
                product_ids.push(product_id);
            }
            if (!isNaN(product_to_id)) {
                product_ids.push(product_to_id);
            }
            return memo;
        }, {});


        $.get('/json/products.json?per=' + product_ids.length, {product_ids: product_ids}, function(products){
            _linked_products = _(products).filter(function(product){
                return _(product_ids).contains(product.id);
            }).map(function(product){
                product['position'] = positions[product['id']];
                product['selected'] = true;
                return product;
            });

            if (_.isFunction(callback)){
                callback(_linked_products);
            }
        });
    }

    function changeFilter() {
        currentPage = 1;
        loadedPage = 0;
        // Reset data on filter changed
        $productSearchResultContainer.html("");
        found_products = [];
        getProductFromServer();
    }

    if ($productSearchResultContainer.length) {
        // Initialize linked products
        populateLinkedProducts(function (products) {
            window.selected_products = products;
            renderFoundProducts();
            renderSelectedProducts();
            initSortable();
        });
        // Initialize product list
        getProductFromServer();
    }

    $('.products-category-filter__create-field').on('change', function (e) {
        e.preventDefault();
        var $textField = $('#products_container_form_name');
        var $ele = $('#products_container_form_product_category_id :selected');
        var text = $ele.text();
        if ($ele.parent('optgroup').length > 0) {
            $textField.attr('readonly', 'readonly');
            text = $ele.parent('optgroup').attr('label') + ' > ' + text;
        } else {
            text = '';
            $textField.removeAttr('readonly');
        }
        $textField.val(text);
    });
});
