$(function () {
    var $page = $('.magazine-issue-details.tags');
    if (!$page.length) {
        return;
    }

    modulejs.require('magazine-issues/tags').init($page);
});

modulejs.define('magazine-issues/tags', [
    'magazine-issues/image-gallery-with-detail',
    'magazine-issues/image-tag-draggable-container',
    'magazine-issues/commons'
], function(
    ImageGalleryWithDetail,
    ImageTagDraggableContainer,
    Commons) {

    var TagsTab = {
        init: function($page) {
            this.$page = $page;
            this.$imageDetail = $page.find('.image-detail');

            this.imageGallery = new ImageGalleryWithDetail({
                $page: $page,
                imageCoverText: 'Add tags',
                detailRenderer: this.renderDetails.bind(this),
                tagsCollectorCallback: this.collectTagsOfCurrentImages.bind(this)
            });
            this.imageGallery.init();
        },

        renderDetails: function(image, $container) {
            var partial = [];
            _.each(this.imageGallery.getSupportedCategories(), function(category) {
                partial.push(HandlebarsTemplates['magazine_issues/tag-icon-block'](
                    _.extend({
                        tagIconDom: HandlebarsTemplates['magazine_issues/tag-icon'](category)
                    }, category)
                ));
            }.bind(this));

            $container.find('.right').empty().append(
                HandlebarsTemplates['magazine_issues/tag-grid']({tagsDom: partial.join('')}));

            initDragAndDropTags(this.$page);
            ImageTagDraggableContainer.init({
                    $page: this.$page,
                    availableTagsOnImages: this.imageGallery.getCurrentImage().tags,
                    getTagCategoryByTypeFnc: this.imageGallery.getTagCategoryByType
            });

            this.$page.find('img.issue-page-image').imagesLoaded(function() {
                $container.find('.right')
                    .css('height', this.$page.find('img.issue-page-image').outerHeight())
            }.bind(this));
        },

        collectTagsOfCurrentImages: function() {
            return ImageTagDraggableContainer.collectTags(this.imageGallery.getCurrentImage().tags);
        }
    };

    function initDragAndDropTags($page) {
        var $droppable = $page.find('.issue-page-image-droppable');

        $page.find('.tag-list .icon-tag-bubble').draggable({
            containment: $droppable,
            appendTo: $droppable,
            helper: 'clone',
            snap: $droppable,
            revert: 'invalid',

            drag: function(e, ui) {
                ImageTagDraggableContainer.handleDraggingInsideImage(ui, $droppable);
            }
        });
    }

    return TagsTab;
});