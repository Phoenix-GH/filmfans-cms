modulejs.define('magazine-issues/image-tag-draggable-container', [
], function() {
    var Container = {
        $page: null,
        /**
         *
         * @param options.$page
         * @param options.availableTagsOnImages
         * @param options.getTagCategoryByTypeFnc
         * @param options.onTagDeleted
         */
        init: function(options) {
            this.$page = options.$page;
            this.getTagCategoryByType = options.getTagCategoryByTypeFnc;

            this.$page.find('img.issue-page-image').imagesLoaded(function() {
                    initContainer(options.$page, options.onTagDeleted);
                    layTagsOnImage(options.$page, options.availableTagsOnImages, options.getTagCategoryByTypeFnc);
                });
        },

        handleDraggingInsideImage: function(ui, $container) {
            _handleDraggingInsideImage(ui, $container);
        },

        collectTags: function(availableTagsOnImages) {
            return collectTagsOnCurrentImages(this.$page, availableTagsOnImages);
        }
    };

    function initContainer($page, onTagDeleted) {
        var $image = $page.find('img.issue-page-image');
        var $container = $page.find('.issue-page-image-droppable');
        $container
            .on('click', '.icon-tag-del', function(event) {
                HotSpottingUtils.confirm(null, function() {
                    $bubble = $(event.currentTarget).parent('.icon-tag-bubble');
                    var tagType = $bubble.attr('data-type');
                    var tagId = $bubble.attr('data-id');
                    if (tagId) {
                        tagId = parseInt(tagId);
                    }
                    $bubble.remove();
                    if (onTagDeleted) {
                        onTagDeleted(tagType, tagId);
                    }
                    $container.attr('check-status-tag', 'true');
                }.bind(this));
            })
            .css('width', $image.outerWidth())
            .css('height', $image.outerHeight())
            .droppable({
                drop: function (e, ui) {
                    var $droppedElem = ui.helper.clone();
                    $droppedElem.removeClass('ui-draggable-dragging')
                        .addClass('ui-draggable-dropped');

                    ui.helper.remove();
                    $container.attr('check-status-tag', 'true');

                    initDraggableBubblesWithinImage($droppedElem, $container);

                    $container.append($droppedElem);
                }
            });

    }

    function initDraggableBubblesWithinImage($draggable, $container) {
        $draggable.draggable({
            containment: $container,
            start: function(event, ui) {
                ui.helper.removeClass('ui-draggable-dropped')
            },
            drag: function(event, ui) {
                _handleDraggingInsideImage(ui, $container);
            }
        });
    }

    function _handleDraggingInsideImage(ui, $container) {
        // comparing to image's top-left corner
        var posTop = ui.position.top;
        var posLeft = ui.position.left;
        var $draggable = ui.helper;

        controlBubbleOrientation($draggable, $container, posTop, posLeft);
    }

    function controlBubbleOrientation($draggable, $container, posTop, posLeft) {
        var draggableWidth = $draggable.outerWidth();
        var draggableHeight = $draggable.outerHeight();

        var isReachingLeftEdge = posLeft <= draggableWidth;
        var isReachingRightEdge = $container.innerWidth() - posLeft <= 2 * draggableWidth;
        var isReachingTopEdge = posTop <= draggableHeight;
        var isReachingBottomEdge = $container.innerHeight() - posTop <= 2 * draggableHeight;

        if (isReachingLeftEdge) {
            if (isReachingBottomEdge) {
                addBubbleOrientationClass($draggable, 'icon-tag-bubble-bottom-left');
            } else {
                addBubbleOrientationClass($draggable, 'icon-tag-bubble-top-left');
            }
        } else if (isReachingRightEdge) {
            if (isReachingBottomEdge) {
                addBubbleOrientationClass($draggable, 'icon-tag-bubble-bottom-right');
            } else {
                addBubbleOrientationClass($draggable, 'icon-tag-bubble-top-right');
            }
        } else if (isReachingTopEdge) {
            addBubbleOrientationClass($draggable, 'icon-tag-bubble-top-left');
        } else if (isReachingBottomEdge) {
            addBubbleOrientationClass($draggable, 'icon-tag-bubble-bottom-left');
        } else {
            // keep the current orientation. This "feature" allow users to place bubble with different orientations
            // to the middle of the image
            //addBubbleOrientationClass($draggable, 'icon-tag-bubble-top-right');
        }
    }
    function addBubbleOrientationClass($draggable, cl) {
        $draggable.removeClass('icon-tag-bubble-top-left icon-tag-bubble-bottom-left '
            + 'icon-tag-bubble-top-right icon-tag-bubble-bottom-right')
            .addClass(cl);
    }

    function collectTagsOnCurrentImages($page, availableTagsOnImages) {
        var $image = $page.find('img.issue-page-image');
        var $container = $page.find('.issue-page-image-droppable');
        var origWidth = $image[0].naturalWidth;
        var origHeight = $image[0].naturalHeight;
        var displayWidth = $image.innerWidth();
        var displayHeight = $image.innerHeight();
        var ratioWidth = origWidth / displayWidth;
        var ratioHeight = origHeight / displayHeight;

        var newTags = [];

        $container.children('.icon-tag-bubble').each(function(index, element) {
            var relativePosTop = $(element).position().top;
            var relativePosLeft = $(element).position().left;

            //console.debug('origHeight:' + origHeight + ' displayHeight: ' + displayHeight + ' relativePosTop: ' + relativePosTop);

            // Transform to position on the actual image (original size).
            function toOrigPosTop(offset) {
                return Math.round((relativePosTop + (offset ? offset : 0)) * ratioHeight);
            }
            function toOrigPosLeft(offset) {
                return Math.round((relativePosLeft + (offset ? offset : 0)) * ratioWidth);
            }

            // transform position to the corner of the bubble
            var bubblePosTop = toOrigPosTop();
            var bubblePosLeft = toOrigPosLeft();
            var orientation = 'top-right';
            if ($(element).hasClass('icon-tag-bubble-top-left')) {
                bubblePosTop = toOrigPosTop();
                bubblePosLeft = toOrigPosLeft();
                orientation = 'top-left';
            } else if ($(element).hasClass('icon-tag-bubble-top-right')) {
                bubblePosTop = toOrigPosTop();
                bubblePosLeft = toOrigPosLeft($(element).outerWidth());
                orientation = 'top-right';
            } else if ($(element).hasClass('icon-tag-bubble-bottom-left')) {
                bubblePosTop = toOrigPosTop($(element).outerHeight());
                bubblePosLeft = toOrigPosLeft();
                orientation = 'bottom-left';
            } else if ($(element).hasClass('icon-tag-bubble-bottom-right')) {
                bubblePosTop = toOrigPosTop($(element).outerHeight());
                bubblePosLeft = toOrigPosLeft($(element).outerWidth());
                orientation = 'bottom-right';
            } else {
                console.error('the bubble element does not contain the position css class');
            }

            // expected structure;
            // {
            //     tag_id: 6,
            //     product_ids: [1, 2, 3],
            //     specification: {
            //     orig_width: 1,
            //         orig_height: 1,
            //         x: 0,
            //         y: 0,
            //         type: 'activewear'
            //     }
            // }

            var tag = {
                tag_id: 0,
                product_ids: null
            };

            var tagId = $(element).attr('data-id');
            if (tagId) {
                tagId = parseInt(tagId);
                tag = _.find(availableTagsOnImages, function(tag) {
                    return tag.id === tagId;
                });
            }

            tag.specification = {
                orig_width: origWidth,
                orig_height: origHeight,
                x: Math.round(bubblePosLeft),
                y: Math.round(bubblePosTop),
                type: $(element).attr('data-type'),
                orientation: orientation
            };

            newTags.push(tag);
        });

        return newTags;
    }

    function layTagsOnImage($page, availableTagsOnImages, getTagCategoryByType) {
        if (!availableTagsOnImages || !availableTagsOnImages.length) {
            return;
        }
        var $image = $page.find('img.issue-page-image');
        var $container = $page.find('.issue-page-image-droppable');
        var origWidth = $image[0].naturalWidth;
        var origHeight = $image[0].naturalHeight;
        var displayWidth = $image.innerWidth();
        var displayHeight = $image.innerHeight();
        var ratioWidth = origWidth / displayWidth;
        var ratioHeight = origHeight / displayHeight;

        _.each(availableTagsOnImages, function(tag) {
            var category = getTagCategoryByType(tag.specification.type);
            if (!category) {
                console.error('No category found for type: ' + tag.specification.type);
            }
            var categoryWithTagId = _.extend({
                tagId: tag.id
            }, category);

            var $draggable = $(HandlebarsTemplates['magazine_issues/tag-icon'](categoryWithTagId));
            $draggable.addClass('ui-draggable ui-draggable-dropped');

            // <div class="icon-tag-bubble ui-draggable ui-draggable-dropped"
            // style="position: absolute; left: 183px; top: 114px;">

            $container.append($draggable);
            $draggable.css('position', 'absolute');

            var draggableWidth = $draggable.outerWidth();
            var draggableHeight = $draggable.outerHeight();

            var origPosTop = tag.specification.y;
            var origPosLeft = tag.specification.x;

            function toRelativeTop(offsetTop) {
                return Math.round((origPosTop / ratioHeight) - (offsetTop ? offsetTop : 0));
            }
            function toRelativeLeft(offsetLeft) {
                return Math.round((origPosLeft / ratioWidth) - (offsetLeft ? offsetLeft : 0));
            }

            var orientation = tag.specification.orientation || 'top-left';
            addBubbleOrientationClass($draggable, 'icon-tag-bubble-' + orientation);

            if (orientation === 'top-left') {
                $draggable.css('top', toRelativeTop());
                $draggable.css('left', toRelativeLeft());
            } else if (orientation === 'top-right') {
                $draggable.css('top', toRelativeTop());
                $draggable.css('left', toRelativeLeft(draggableWidth));
            } else if (orientation === 'bottom-left') {
                $draggable.css('top', toRelativeTop(draggableHeight));
                $draggable.css('left', toRelativeLeft());
            } else if (orientation === 'bottom-right') {
                $draggable.css('top', toRelativeTop(draggableHeight));
                $draggable.css('left', toRelativeLeft(draggableWidth));
            } else {
                $draggable.css('top', toRelativeTop());
                $draggable.css('left', toRelativeLeft());
            }

            initDraggableBubblesWithinImage($draggable, $container);
        });
    }

    return Container;
});