modulejs.define('magazine-issues/image-gallery', [
    'magazine-issues/commons'
], function(Commons) {

    var POLL_INTERVAL = 15;

    /**
     * @param options.$imagePane
     * @param options.imagesLoadedCallback
     * @param options.imageCoverText
     * @param options.imageClickCallback {Number} receives page image object
     * @param options.onlyLoadImagesWithTags {boolean}
     * @param options.supportHideShow
     *
     * @constructor
     */
    function ImageGallery(options) {
        this.$imagePane = options.$imagePane;
        this.imagesLoadedCallback = options.imagesLoadedCallback;
        this.imageCoverText = options.imageCoverText;
        this.imageClickCallback = options.imageClickCallback;
        this.onlyLoadImagesWithTags = options.onlyLoadImagesWithTags;
        this.supportHideShow = options.supportHideShow;

        this.images = [];

        HotSpottingUtils.registerHandlebarsCompareHelper();

        if (this.imageClickCallback) {
            this.$imagePane.on('click', '.image-page-overlay', function (event) {
                var pageId = parseInt($(event.currentTarget).parents('.image-page').attr('data-id'));

                var img = _.find(this.images, function(img) {
                    return img.id === pageId;
                });
                if (img) {
                    this.imageClickCallback(img);
                } else {
                    console.error('cannot find issue image with id: ' + pageId);
                }
            }.bind(this));
        }
        if (this.supportHideShow) {
            this.$imagePane
                .on('click', '.image-page-do-hide', function(event) {
                    this._setImageVisible(event, false);
                }.bind(this))
                .on('click', '.image-page-hidden', function(event) {
                    this._setImageVisible(event, true);
                }.bind(this))
            ;
        }
    }

    ImageGallery.prototype = {

        loadPageImages: function(dontShowIndicator) {
            $.ajax({
                url: Commons.getIssueJsonUrl('load_images'),
                data: {
                    only_with_tags: this.onlyLoadImagesWithTags,
                    only_visible: this.supportHideShow ? false: true
                },
                method: 'GET',
                beforeSend: function() {
                    if (!dontShowIndicator) {
                        HotSpottingUtils.showInlineWaiting($('.inline-waiting-pane'), 'Loading pages...');
                    }
                },
                complete: function() {
                    if (!dontShowIndicator) {
                        HotSpottingUtils.hideInlineWaiting($('.inline-waiting-pane'));
                    }
                }
            })
                .done(
                    function (result) {
                        if (result.error) {
                            HotSpottingUtils.showError(result.error);
                        } else {
                            this.buildPageContent(result);
                        }
                    }.bind(this)
                )
                .fail(Commons.onAjaxError);
        },

        _loadPageImagesInBackground: function() {
            this.loadPageImages(true);
        },

        buildPageContent: function(data) {
            this.images = data.images;
            this.$imagePane.css('display', !data.pdf_file ? 'none' : 'block');

            if (!data.pdf_file) {
                if (this.imagesLoadedCallback) {
                    this.imagesLoadedCallback(data);
                }
                return;
            }

            this.$imagePane.find('.crawling-in-progress').remove();
            if (data.pdf_file.missing_images) {
                HotSpottingUtils.showInlineWaiting(
                    this.$imagePane,
                    buildCrawlingInProgressMessage(data.pdf_file.missing_images),
                    true
                );

                setTimeout(this._loadPageImagesInBackground.bind(this), POLL_INTERVAL * 1000);
            }

            renderImagePane(data.images, this.$imagePane, this.imageCoverText, this.supportHideShow);

            if (this.imagesLoadedCallback) {
                this.imagesLoadedCallback(data);
            }
        },

        redrawImageList: function() {
            renderImagePane(this.images, this.$imagePane, this.imageCoverText, this.supportHideShow);
        },

        getImage: function(id) {
            return _.find(this.images, function(img) {
                return id === img.id;
            });
        },

        replaceImage: function(image) {
            for (var i = 0; i < this.images.length; i++) {
                if (this.images[i].id === image.id) {
                    this.images[i] = image;
                    return;
                }
            }
            console.error('cannot find image id= ' + image.id + ' in the list');
        },

        getNextImage: function(image) {
            var index = indexOf(image, this.images);
            if (index < 0 || index >= this.images.length - 1) {
                return null;
            }
            return this.images[index + 1];
        },

        getPreviousImage: function(image) {
            var index = indexOf(image, this.images);
            if (index <= 0) {
                return null;
            }
            return this.images[index - 1];
        },

        isFirstImage: function(image) {
            if (!image || !this.images || !this.images.length) {
                return true;
            }
            return image.id === this.images[0].id;
        },

        isLastImage: function(image) {
            if (!image || !this.images || !this.images.length) {
                return true;
            }
            return image.id === this.images[this.images.length - 1].id;
        },

        _setImageVisible: function(event, visilble) {
            var dataIdElem = $(event.currentTarget).parents('.image-page');
            var pageId = parseInt(dataIdElem.attr('data-id'));
            var imageDom = dataIdElem.parent();

            var image = this.getImage(pageId);
            $.ajax({
                url: Commons.getIssueJsonUrl('set_visible'),
                data: {
                    page_id: pageId,
                    visible: visilble
                },
                method: 'POST',
                beforeSend: function() {
                    HotSpottingUtils.showInlineWaiting($('.inline-waiting-pane'), 'Saving...');
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
                            image.visible = visilble;
                            imageDom.replaceWith(renderOneImage(image, this.imageCoverText, this.supportHideShow))
                        }
                    }.bind(this)
                )
                .fail(Commons.onAjaxError);
        }

    };

    function renderImagePane(images, $imagePane, imageCoverText, supportHideShow) {
        var $images = $imagePane.find('.images');
        $($images).addClass('clearfix');
        $images.empty();
        if (images && images.length) {
            var imgArr = [];

            var itemOnRow = 0;
            _.each(images, function(image) {
                // if (itemOnRow == 6) { // changing this, must also change the grid class in the template
                //
                //     imgArr.push('</div><div class="row">');
                //     itemOnRow = 0;
                // }
                imgArr.push(renderOneImage(image, imageCoverText, supportHideShow));
                itemOnRow++;
            });
            // imgArr.push('</div>');
            ImagesPagation(imgArr);
            //$images.append(imgArr.join(''));
        }
    }
    function ImagesPagation(imageArr) {
        var showPerPage = 6;
        var numberOfItem = imageArr.length;
        var numberOfPage = Math.ceil(numberOfItem / showPerPage);

        var paginationHTML = "<div class='pagination-image'></div>";
        $('.image-pane .images').append(paginationHTML);

        var CurrentPageHTML = '<input type="hidden" class="current_page" value="">';
        $('.image-pane .images').append(CurrentPageHTML);

        $('.image-pane .images .current_page').val(0);

        var navigation_html = '<a class="previous_link" href="javascript:void(0);">Prev</a>';
        var currentLink = 0;
        while(numberOfPage > currentLink){
            navigation_html += '<a class="page_link"  longdesc="' + currentLink +'">'+ (currentLink + 1) +'</a>';
            currentLink++;
        }
        navigation_html += '<a class="next_link" href="javascript:void(0);">Next</a>';
        $('.image-pane .images').find('.pagination-image').append(navigation_html);
        $('.pagination-image .page_link:first').addClass('active_page');
        var newImageArr = imageArr.slice(0, showPerPage);
        $('.image-pane .images').prepend(newImageArr);
        
        //go to page
        $('.images .page_link').on('click', function () {
            var pageNum = $(this).attr('longdesc');
            loadPagination(pageNum, imageArr)
        });

        // go to previous page
        $('.image-pane .previous_link').on('click', function () {
            var pageNum = parseInt($('.image-pane .current_page').val()) - 1;
            if (pageNum >= 0 ){
                loadPagination(pageNum, imageArr);
            }
        });

        // go to next page
        $('.image-pane .next_link').on('click', function () {
            var pageNum = parseInt($('.image-pane .current_page').val()) + 1;
            if (pageNum < numberOfPage ){
                loadPagination(pageNum, imageArr);
            }

        });
    }

    function renderOneImage(image, imageCoverText, supportHideShow) {
        if (!image || !image.url_thumbnail) {
            return '';
        }
        return HandlebarsTemplates['magazine_issues/image_thumbnail']({
            id: image.id,
            url: image.url_thumbnail,
            description: image.description,
            overlayText: imageCoverText,
            numberOfTags: image.tags ? image.tags.length : 0,
            numberOfProducts: countProducts(image),
            visible: image.visible,
            supportHideShow: supportHideShow
        });
    }

    function countProducts(image) {
        if (!image.tags) {
            return 0;
        }
        return _.reduce(image.tags, function(sum, tag){
            return sum + (tag.products ? tag.products.length : 0);
        }, 0);
    }

    function indexOf(image, imageList) {
        if (!image || !imageList) {
            return -1;
        }

        for (var i = 0; i < imageList.length; i++) {
            if (imageList[i].id === image.id) {
                return i;
            }
        }
        return -1;
    }

    function buildCrawlingInProgressMessage(remaining) {
        if (remaining) {
            return ['<b>', remaining, '</b>',
                remaining > 1 ? ' pages are ' : ' page is ',
                ' being converted to ',
                remaining > 1 ? ' images ' : ' image ',
                ' Once completed, ',
                remaining > 1 ? ' they ' : ' it ',
                ' will be displayed in the list below. '
            ].join(' ')
        } else {
            return 'All PDF pages are being converted to images. Once completed, ' +
                ' they will be displayed in the list below.';
        }
    }

    return ImageGallery;
});

function loadPagination(pageNum, imageArr) {
    var showPerPage = 6;
    var startFrom = pageNum * showPerPage;
    var endon = startFrom + showPerPage;
    var newImgArr = imageArr.slice(startFrom,endon);
    $('.image-pane .images .col-sm-4').remove();
    $('.image-pane .images').prepend(newImgArr);
    $('.page_link[longdesc=' + pageNum +']').addClass('active_page').siblings('.active_page').removeClass('active_page');
    $('.image-pane .current_page').val(pageNum);
}