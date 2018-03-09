
$(function () {
    var $page = $('.magazine-issue-details.upload');
    if (!$page.length) {
        return;
    }

    modulejs.require('magazine-issues/upload').init();
});


modulejs.define('magazine-issues/upload', [
    'magazine-issues/image-gallery',
    'magazine-issues/commons'
], function(ImageGallery, Commons) {

    var $page = $('.magazine-issue-details.upload');
    var $uploadForm = $page.find('#magazine_issue_pdf_form');
    var $imagePane = $page.find('.image-pane');
    var imageGallery = new ImageGallery({
        $imagePane: $imagePane,
        imagesLoadedCallback: onImagesLoaded,
        supportHideShow: true
    });

    var IssueUpload = {
        init: function() {
            initDropZone();

            $page
                .on('click', '.btn-reupload', function() {
                    Dropzone.forElement('#magazine_issue_pdf_form').removeAllFiles();
                    $uploadForm.css('display', 'block')
                        .attr('waiting-reupload', 'true');
                    $imagePane.css('display', 'none').find('.images').empty();
                });

            imageGallery.loadPageImages();
        }
    };

    function onImagesLoaded(data) {
        if ($uploadForm.attr('waiting-reupload') != 'true') {
            $uploadForm.css('display', !data.pdf_file ? 'block' : 'none');
        } else {
            $imagePane.css('display', 'none');
        }
    }

    function initDropZone() {
        Dropzone.options.magazineIssuePdfForm = { // The camelized version of the ID of the form element
            url: $uploadForm.attr('action'),
            headers: {
                'Accept': 'application/vnd.ulab.v0+json'
            },
            maxFilesize: 700,
            filesizeBase: 1024,
            addRemoveLinks: true,
            acceptedFiles: '.pdf',
            maxFiles: 1,
            createImageThumbnails: false,
            dictDefaultMessage: '<span class="fa fa-cloud-upload ic-cloud-upload"></span><br>'
            + '<span class="upload-intro">Simply drag and drop PDF file<br>or<br>click on this area to upload<br></span>'
            + '<span class="upload-notice">Notice: Once uploaded, the first page will be used as the cover image if there is no cover image uploaded yet</span>',
            dictResponseError: 'Failed to upload the file. Please try again',

            success: function(file, response) {
                $uploadForm.attr('waiting-reupload', null);
                savePdfInfo(file.name, response);
            },
            removedfile: function(file) {
                return file.previewElement ? file.previewElement.parentNode.removeChild(file.previewElement) : (void 0);
            },
            error: function(file, response) {
                console.error(response);
                $(file.previewElement).addClass('dz-error');
                errorElement = file.previewElement.querySelector("[data-dz-errormessage]");
                return errorElement.textContent = "Error when uploading this pdf file";
            },
            uploadprogress: function(file, progress) {
                $('.dz-progress .dz-upload').addClass('loading-upload-file');
            },
            init: function() {
            }
        };
    }

    function savePdfInfo(actualFileName, ulabApiResponse) {
        var data = ulabApiResponse.data;
        $.ajax({
            url: Commons.getIssueJsonUrl('on_pdf_uploaded'),
            method: 'POST',
            data: {
                pdf_user_file_name: actualFileName,
                pdf_file_name: data.file_name,
                pdf_url: data.pdf,
                image_url_prefix: data.image_url_template,
                total_pages: data.total_pages
            },
            beforeSend: function() {
                HotSpottingUtils.showInlineWaiting($uploadForm);
            },
            complete: function() {
                HotSpottingUtils.hideInlineWaiting($uploadForm);
            }
        }).done(function(result) {
            if (result.error) {
                HotSpottingUtils.showError(result.error);
            } else {
                imageGallery.buildPageContent(result);
            }
        }).fail(Commons.onAjaxError);
    }

    return IssueUpload;
});
