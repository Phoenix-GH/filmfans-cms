
modulejs.define('magazine-issues/image-gallery-with-detail', [
    'magazine-issues/image-gallery',
    'magazine-issues/commons'
], function(ImageGallery, Commons) {

    var supportedCategories = null;

    /**
     *
     * @param options.$page
     * @param options.imageCoverText
     * @param options.tagListLabel
     * @param options.detailRenderer receives and image data object
     * @param options.onBackToGallery
     * @param options.onDetailRendered receives and image data object and the container DOM
     * @param options.onlyLoadImagesWithTags {boolean}
     * @param options.imagesLoadedCallback
     * @param options.tagsCollectorCallback
     *
     * @constructor
     */
    function ImageGalleryWithDetail(options) {
        this.$page = options.$page;
        this.detailRenderer = options.detailRenderer;
        this.onBackToGallery = options.onBackToGallery;
        this.onDetailRendered = options.onDetailRendered;
        this.imagesLoadedCallback = options.imagesLoadedCallback;
        this.tagsCollectorCallback = options.tagsCollectorCallback;

        this.$imagePane = this.$page.find('.image-pane');
        this.$imageDetail = this.$page.find('.image-detail');
        this.imageGallery = new ImageGallery({
            $imagePane: this.$imagePane,
            imagesLoadedCallback: this._onImageListLoaded.bind(this),
            imageCoverText: options.imageCoverText,
            imageClickCallback: this._showDetail.bind(this),
            onlyLoadImagesWithTags: options.onlyLoadImagesWithTags
        });
    }

    ImageGalleryWithDetail.prototype = {
        init: function() {
            this._initActions();

            this.imageGallery.loadPageImages();
        },

        getSupportedCategories: function() {
            return supportedCategories;
        },

        getCurrentImage: function() {
            return this.currentImage;
        },

        getTagCategoryByType: function(type) {
           return _.find(supportedCategories, function(cat) {
               return cat.type === type;
           });
        },
        _initActions: function () {
            this.$imageDetail.
            on('click', '.back-handle', function(event) {
                this._confirmDirty(function() {
                    // redraw the list since the number of tags/products may change
                    this.imageGallery.redrawImageList();

                    this.$imageDetail.css('display', 'none');
                    this.$imagePane.css('display', 'block');
                    removeUrlHash();
                    if (this.onBackToGallery) {
                        this.onBackToGallery();
                    }
                }.bind(this));
            }.bind(this))
                .on('click', '.previous-handle', function() {
                    var img = this.imageGallery.getPreviousImage(this.currentImage);
                    this._confirmDirty(function() {
                        if (img) {
                            this._showDetail(img);
                        }
                    }.bind(this));
                }.bind(this))
                .on('click', '.next-handle', function() {
                    var img = this.imageGallery.getNextImage(this.currentImage);
                    this._confirmDirty(function() {
                        if (img) {
                            this._showDetail(img);
                        }
                    }.bind(this));
                }.bind(this))
                .on('click', '.btn-reset-img-detail', function() {
                    this._onReset();
                }.bind(this))
                .on('click', '.btn-save-img-detail', function(e) {
                    e.preventDefault();
                    this._onSave();
                }.bind(this));
        },

        _onImageListLoaded: function (data) {
            var bookmarkedId = extractPageIdFromUrlHash();
            if (!!bookmarkedId) {
                if (this.currentImage && this.currentImage.id == bookmarkedId) {
                    this._visibleImageDetail();
                    // we are being on this image. No re-draw otherwise all non-save bubbles will be lost
                    return;
                }
                var image = this.imageGallery.getImage(bookmarkedId);
                if (image) {
                    this._showDetail(image);
                    return;
                }
            }

            if (this.imagesLoadedCallback) {
                this.imagesLoadedCallback(data);
            }
        },

        _showDetail: function(image) {
            addPageToUrlHash(image.id);

            loadTagCategories(function() {
                this._showImageDetail(image);
            }.bind(this));
        },

        _showImageDetail: function(image) {
            // deep copy
            this.currentImage = $.extend(true, {}, image);

            this._visibleImageDetail();

            var partial = HandlebarsTemplates['magazine_issues/navigable-image-detail']({
                description: image.description,
                url: image.url_full
            });

            var $container = this.$imageDetail.find('.image-detail-container');
            $container.empty().append(partial);
            this.detailRenderer(image, $container);
            this._updateNextPreviousStatus();

            if (this.onDetailRendered) {
                this.onDetailRendered(image);
            }
        },

        _visibleImageDetail: function() {
            this.$imageDetail.css('display', 'block');
            this.$imagePane.css('display', 'none');
        },

        _updateNextPreviousStatus: function () {
            this.$imageDetail.find('.previous').css('visibility',
                this.imageGallery.isFirstImage(this.currentImage) ? 'hidden' : 'visible');
            this.$imageDetail.find('.next').css('visibility',
                this.imageGallery.isLastImage(this.currentImage) ? 'hidden' : 'visible');
        },

        _onReset: function() {
            HotSpottingUtils.confirm(null, function() {
                this._showDetail(this.imageGallery.getImage(this.currentImage.id));
            }.bind(this));
        },

        _onSave: function() {
            if (!this.tagsCollectorCallback) {
                console.error('no tagsCollectorCallback provided');
                return;
            }

            var tags = this.tagsCollectorCallback();
            if (!tags) {
                return;
            }

            var data = {
                page_id: this.currentImage.id,
                tags: tags
            };

            $.ajax({
                url: Commons.getIssueJsonUrl('save_tags'),
                method: 'POST',
                data: JSON.stringify(data),
                processData: false,
                dataType: "json",
                contentType: "application/json",
                beforeSend: function() {
                    HotSpottingUtils.showBlockWaiting($('.image-detail'), 'Saving...');
                },
                complete: function() {
                    HotSpottingUtils.hideBlockWaiting($('.image-detail'));
                }

            })
            .done(function(image) {
                this.imageGallery.replaceImage(image);
                this._showDetail(image);
            }.bind(this))
            .fail(Commons.onAjaxError);
        },

        _confirmDirty: function (onConfirm) {
            // redraw the list since the number of tags/products may change;
            var $image = this.$imageDetail.find('.issue-page-image-droppable');
            if($image.attr('check-status-tag')){
                HotSpottingUtils.confirm('There is unsaved change, do you still want to leave?', function() {
                    onConfirm();
                }.bind(this));
            } else{
                onConfirm();
            }
        }
    };

    function loadTagCategories(onCategoryLoaded) {
        if (supportedCategories) {
            onCategoryLoaded();
            return;
        }

        $.ajax({
            url: Commons.getIssueJsonUrl('load_all_categories'),
            method: 'GET',
            beforeSend: function() {
                HotSpottingUtils.showInlineWaiting($('.inline-waiting-pane'), 'Loading pages...');
            },
            complete: function() {
                HotSpottingUtils.hideInlineWaiting($('.inline-waiting-pane'));
            }
        })
        .done(function(categories) {
            supportedCategories = categories;
            onCategoryLoaded();
        })
        .fail(Commons.onAjaxError);
    }

    function addPageToUrlHash(pageId) {
        window.location.hash = 'pgid:' + pageId;
    }
    function extractPageIdFromUrlHash() {
        var hash = window.location.hash;
        if (!hash) {
            return null;
        }
        var arr = hash.split('pgid:');
        if (arr.length < 2) {
            return null;
        }
        var id = parseInt(arr[1]);
        if (_.isNaN(id)) {
            return null;
        }
        return id;
    }

    function removeUrlHash() {
        window.location.hash = '';
    }

    return ImageGalleryWithDetail;
});