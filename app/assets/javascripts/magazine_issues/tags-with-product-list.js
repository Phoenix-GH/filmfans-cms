
modulejs.define('magazine-issues/tags-with-product-list', [
], function() {
    var TagsWithProductList = {
        init: function(options) {
            this.getTagCategoryByType = options.getTagCategoryByType;
            this.withProductRemovalMask = options.withProductRemovalMask;
            this.tagToolTip = options.tagToolTip;
            this.productListHelpText = options.productListHelpText;
        },

        render: function(tags) {
            var partial = [];
            _.each(tags, function(tag) {
                var category = this.getTagCategoryByType(tag.specification.type);
                category = _.extend({ tagId: tag.id, tagToolTip: this.tagToolTip }, category);

                var productsDom = [];
                _.each(tag.products, function(product) {
                    var $productDom = $(HandlebarsTemplates['products/search_result'](product));
                    $productDom.addClass('widget-tag-product ui-draggable-dropped');
                    if (this.withProductRemovalMask) {
                        $productDom.append(this.productRemovalDom());
                    }
                    if (product.available === false) {
                        $productDom.append('<div class="out-of-stock"></div>');
                    }
                    productsDom.push($productDom[0].outerHTML);
                }.bind(this));

                if (this.productListHelpText) {
                    productsDom.push('<div class="hs-icon-ic-add help-text">' + this.productListHelpText + '</div>');
                }

                partial.push(
                    HandlebarsTemplates['magazine_issues/tag-product-row']({
                        tagIcon: HandlebarsTemplates['magazine_issues/tag-icon-block'](
                            _.extend(
                                {
                                    tagIconDom: HandlebarsTemplates['magazine_issues/tag-icon'](category)
                                },
                                category)
                        ),
                        productsDom: productsDom.join('')
                    }));
            }.bind(this));

            return HandlebarsTemplates['magazine_issues/tags-with-products-container']({
                tagProductRowsDom: partial.join('')
            });
        },

        productRemovalDom: function() {
            return '<div class="widget-remove-product-tag"><div class="hs-icon-ic-close-circle"></div></div>';
        }
    };

    return TagsWithProductList;
});