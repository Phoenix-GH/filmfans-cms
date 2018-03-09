$(function () {
    var $page = $('.magazine-issue-details.tag_products');
    if (!$page.length) {
        return;
    }

    modulejs.require('magazine-issues/tag_products').init($page);
});

modulejs.define('magazine-issues/tag_products', [
    'magazine-issues/image-gallery-with-detail',
    'magazine-issues/image-tag-draggable-container',
    'magazine-issues/tags-with-product-list'
], function(ImageGalleryWithDetail, ImageTagDraggableContainer, TagsWithProductList) {

    var  TagProducts  = {
        init: function($page) {
            this.$page = $page;
            this.imageGallery = new ImageGalleryWithDetail({
                $page: $page,
                imageCoverText: 'Add products',
                tagListLabel: 'Tags with products',
                detailRenderer: this.renderDetails.bind(this),
                onBackToGallery: this.onBackToGallery,
                onDetailRendered: this.onDetailRendered,
                onlyLoadImagesWithTags: true,
                imagesLoadedCallback: this.onImagesLoaded.bind(this),
                tagsCollectorCallback: this.collectTagProductsOfCurrentImages.bind(this)
            });
            this.imageGallery.init();
            TagsWithProductList.init({
                getTagCategoryByType: this.imageGallery.getTagCategoryByType,
                withProductRemovalMask: true,
                tagToolTip: 'Click to reveal this tag on the image',
                productListHelpText: 'Drag and drop products here'
            });

            this.initActions();
        },

        initActions: function() {
            var $imageDetail = this.$page.find('.image-detail');
            $imageDetail.on('click', '.widget-remove-product-tag .hs-icon-ic-close-circle', removeTaggedProduct);
            $(document).bind(window.PRODUCT_JSON_PRODUCTS_LOADED_EVENT, function() {
                initProductsDraggable(this.$page);
            }.bind(this));

            function flashItem($item) {
                $('html, body').animate({
                        scrollTop: $item.offset().top
                    },
                    {
                        duration: 500,
                        complete: function(event) {
                            $item.fadeIn(200).fadeOut(200).fadeIn(200).fadeOut(200).fadeIn(200);
                        }
                    }
                );
            }

            // jumping to tag on image
            var $tagsWithProducts = this.$page.find('.tags-with-products');
            $tagsWithProducts.on('click', '.icon-tag-bubble', function(event) {
                var tagId = $(event.currentTarget).attr('data-id');
                var $bubble = $imageDetail.find('.issue-page-image-droppable [data-id="' + tagId + '"]');
                if ($bubble.length) {
                    flashItem($bubble);
                }
            });

            // jumping to tag with products
            this.$page.find('.image-detail-container').on('click', '.icon-tag-bubble', function(event) {
                var tagId = $(event.currentTarget).attr('data-id');
                var $bubble = $tagsWithProducts.find('.icon-tag-bubble[data-id="' + tagId + '"]');
                if ($bubble.length) {
                    flashItem($bubble);
                }
            });
        },

        renderDetails: function(image, $container) {
            $container.find('.right').remove();

            var $tagProductList = $(TagsWithProductList.render(image.tags));
            this.$page.find('.tags-with-products').empty().append($tagProductList);

            var $productListCol = this.$page.find('.products-search__search-products-col');
            $tagProductList.css('height',
                    this.$page.find('.products-search__results').outerHeight()
                    + parseInt($productListCol.css('padding-top'))
                    + parseInt($productListCol.css('padding-bottom'))
                );

            initProductDroppable(this.$page);

            ImageTagDraggableContainer.init({
                $page: this.$page,
                availableTagsOnImages: this.imageGallery.getCurrentImage().tags,
                getTagCategoryByTypeFnc: this.imageGallery.getTagCategoryByType,
                onTagDeleted: this._handleTagDeleted.bind(this)
            });
        },

        onBackToGallery: function() {
            this.$page.find('.products-search').css('display', 'none');
        },

        onDetailRendered: function(image) {
            this.$page.find('.products-search').css('display', 'block');
        },

        onImagesLoaded: function(data) {
            if (data.pdf_file && !data.pdf_file.missing_images && (!data.images || !data.images.length)) {
                HotSpottingUtils.showError('There is no image having tags. You have to add tags to images first');
            }
        },

        collectTagProductsOfCurrentImages: function() {
            var  currentTagsOnImages = ImageTagDraggableContainer.collectTags(this.imageGallery.getCurrentImage().tags);

            var newTagsOnPage = [];

            this.$page.find('.tag-product-list .widget-list-product-tag').each(function(index, element) {
                var $tagIcon = $(element).find('.icon-tag-bubble');
                var tagType = $tagIcon.attr('data-type');
                var tagId = parseInt($tagIcon.attr('data-id'));

                var tag = _.find(currentTagsOnImages, function(tag) {
                    return tag.id === tagId;
                });
                if (!tag) {
                    console.error('Cannot find existing tag with ID= ' + tagId);
                    return;
                }

                var productIds = [];
                $(element).find('.widget-tag-product .js-result-checkbox').each(function(index, el) {
                    productIds.push(parseInt($(el).attr('data-id')));
                });
                tag.product_ids = productIds;

                newTagsOnPage.push(tag);
            });

            return newTagsOnPage;
        },

        _handleTagDeleted: function(removedTagType, removedTagId) {
            this.$page.find('.tag-product-list .widget-list-product-tag').each(function(index, element) {
                var $tagIcon = $(element).find('.icon-tag-bubble');
                var tagType = $tagIcon.attr('data-type');
                var tagId = parseInt($tagIcon.attr('data-id'));
                if (removedTagId === tagId) {
                    element.remove();
                }
            });
        }
    };

    function removeTaggedProduct(event) {
        HotSpottingUtils.confirm(null, function() {
            $(event.currentTarget).parents('.widget-tag-product').remove();
            $('.issue-page-image-droppable').attr('check-status-tag', 'true');
        });
    }

    function initProductsDraggable($page) {
        $page.find(".products-search__results .result").draggable({
            helper: 'clone',
            cursor: 'move',
            revert: 'invalid',
            zIndex: 100,

            start: function (e,ui) {
                ui.helper.addClass('widget-tag-product')
            }
        });
    }

    function initProductDroppable($page) {
        var $container = $page.find('.issue-page-image-droppable');
        $page.find(".widget-list-product-tag .container-list-product-tagged").droppable({
                hoverClass: "hover-area-droppable",
                drop: function (event, ui) {
                    if (doesProductExist(ui.helper.find('.js-result-checkbox').attr('data-id'), $(this))) {
                        HotSpottingUtils.errorModal("The product has already been associated with the tag. You can't drag a product to a tag twice");
                        return;
                    }

                    $droppedElem = ui.helper.clone();
                    $droppedElem
                        .removeClass('ui-draggable-dragging')
                        .addClass('ui-draggable-dropped widget-tag-product')
                        .css('position', 'relative')
                        .css('z-index', '')
                        .css('top', '')
                        .css('left', '');

                    if ($droppedElem.find('.js-result-checkbox').data('available') === false) {
                        $droppedElem.append('<div class="out-of-stock"></div>');
                    }

                    ui.helper.remove();
                    $(this).append($droppedElem);
                    $container.attr('check-status-tag', 'true');
                    var removeIcon = TagsWithProductList.productRemovalDom();
                    $droppedElem.append(removeIcon)

                }
            });
    }

    function doesProductExist(pid, $productList) {
        var existed = false;
        $productList.find('.widget-tag-product .js-result-checkbox').each(function(index, el) {
            if (pid == $(el).attr('data-id')) {
                existed = true;
            }
        });
        return existed;
    }

    return TagProducts;
});