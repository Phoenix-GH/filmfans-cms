$(function () {
    var $page = $('.magazine-issue-details.confirm');
    if (!$page.length) {
        return;
    }

    modulejs.require('magazine-issues/confirm').init($page);
});

modulejs.define('magazine-issues/confirm', [
    'magazine-issues/tags-with-product-list',
    'magazine-issues/commons'
], function(
    TagsWithProductList,
    Commons
) {

    var $page = $('.magazine-issue-details.confirm');

    Confirm =  {
        init: function () {
            loadPageImages();
        }
    };

    function loadPageImages() {
        $.ajax({
            url: Commons.getIssueJsonUrl('load_images'),
            data: {
                only_with_tags: true,
                only_visible: true,
                include_tag_categories: true
            },
            method: 'GET',
            beforeSend: function() {
                HotSpottingUtils.showInlineWaiting($('.inline-waiting-pane'), 'Loading pages...');
            },
            complete: function() {
                HotSpottingUtils.hideInlineWaiting($('.inline-waiting-pane'));
            }
        })
        .done(
            function (result) {
                if (result.error) {
                    HotSpottingUtils.showError(result.error);
                } else {
                    buildPageContent(result);
                }
            }.bind(this)
        )
        .fail(Commons.onAjaxError);
    }

    function buildPageContent(data) {
        var tagCategories = data.tag_categories;
        function getTagCategory(type) {
            return _.find(tagCategories, function(cat) {
                return cat.type === type;
            });
        }

        TagsWithProductList.init({
            getTagCategoryByType: getTagCategory,
            withProductRemovalMask: false
        });

        var url = $('#_issue_page_edit_url_base').val() + '#pgid:';

        var doms = [];
        var first = true;
        _.each(data.images, function(image) {
            if (!first) {
                doms.push('<div class="page-separator"> </div>');
            }

            first = false;
            doms.push(HandlebarsTemplates['magazine_issues/confirmed-image'](
                {   image: image,
                    editUrl: url,
                    tagsProductsDom: TagsWithProductList.render(image.tags) //generateTagList(image, data.tag_categories)
                }));
        });
        $page.find('.confirm-container').append(doms.join(''))
    }
    
    //
    // function generateTagList(image, categories) {
    //     var tagsPartial = [];
    //     _.each(image.tags, function(tag) {
    //         var category = getTagCategory(tag.specification.type, categories);
    //         tagsPartial.push(HandlebarsTemplates['magazine_issues/tag-icon-block'](
    //             _.extend({
    //                 tagIconDom: HandlebarsTemplates['magazine_issues/tag-icon'](category)
    //             }, category)
    //         ));
    //     });
    //     return tagsPartial.join('');
    // }
    // function getTagCategory(type, categories) {
    //     return _.find(categories, function(cat) {
    //         return cat.type === type;
    //     });
    // }

    return Confirm;
});