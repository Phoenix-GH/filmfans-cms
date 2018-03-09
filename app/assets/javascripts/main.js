$(function () {
    'use strict';
    var console = window.console || { log: function () { } };
    var single = true, isCover = true;
    var typeCropper = 'avatar';
    var imageBg = {}, imageSingle = {}, imageCover = {}, oriImage = {};
    var url = {}, urlSingleCrop = {}, urlBgCrop = {}, urlCoverCrop = {}, imgPreviewBackground = {}, imgPreviewCover = {}, imgPreviewSingle = {};

    $(document).on('click', '.cropper', function() {
      var $imageOri = $(this).clone();
      if($imageOri.attr('data-cropper-type')) typeCropper = $imageOri.attr('data-cropper-type');
      urlBgCrop = typeCropper === 'magazine' ? $(this).attr('coverCropUrl') : $(this).attr('src');
      urlCoverCrop = typeCropper === 'magazine' ? $(this).attr('src') : $(this).attr('coverCropUrl');
      urlSingleCrop = $(this).attr('src');
      $imageOri.attr('src', $imageOri.attr('data-original-picture-url'));
      if((typeCropper === 'event') || (typeCropper == 'tv-show') || (typeCropper == 'magazine') || (typeCropper == 'collection')) {
        single = false;
        doubleCropper($imageOri);
      } else {
        single = true;
        singleCropper($imageOri);
      }

      $('#myModal').removeClass('hide');
      $('.review-phone-' + typeCropper, '#myModal').removeClass('hide');
      imgPreviewBackground = '.review-phone-' + typeCropper + ' .img-preview-background';
      imgPreviewCover = '.review-phone-' + typeCropper + ' .img-preview-cover';
      imgPreviewSingle = '.review-phone-' + typeCropper + ' .img-preview';
      document.getElementById("rangeZoom").value = 0;
      url = $imageOri.attr("data-update-url");
    });

    $('#myModal .btn-cancel').on('click', function() {
      single ? cancelSingleImage() : cancelDoubleImage();
      reset();
    });
    // Options
    $('.docs-toggles').on('change', 'input', function () {
    });
    // Methods
    $('.btn-save').on('click', function () {
      $.ajax({
        method: "PUT",
        data: single ? saveSingleImage() : saveDoubleImage(),
        url: url,
        success: function(result){
          single ? cancelSingleImage() : cancelDoubleImage();
          reset();
          //For browser knows load image.
          var newUrl = $(result).attr("src") + "?" + new Date().getTime();
          $("img[data-id='" + $(result).attr("data-id") + "']").replaceWith($(result).attr('class', 'cropper'));
          $("img[data-id='" + $(result).attr("data-id") + "']").attr("src", newUrl);
        }});
    });

    var rng = document.getElementById("rangeZoom");
    if(rng) {
      rng.oninput = function () {
          var oldV = parseFloat($('#oldRangeValue').text());
          var change = 0;
          var data = {};
          change = this.value - oldV;
          console.log(change);
          single ? imageSingle.$image.cropper("zoom", change) : isCover ? imageCover.$image.cropper("zoom", change) : imageBg.$image.cropper("zoom", change);
          $('#oldRangeValue').text(this.value);
      };
    }

    $('#cover').on('click', function() {
      if(!$(this).hasClass('active')) {
        $(this).addClass('active');
        $('#background').removeClass('active');
        swap(true);
      }
    });

    $('#background').on('click', function() {
      if(!$(this).hasClass('active')) {
        $(this).addClass('active');
        $('#cover').removeClass('active');
        swap(false);
      }
    });

    function getDataPro(data) {
      if(data) {
        var ratio = data.split('x');
        return ratio[0] / ratio[1];
      }
      return 1;
    }

    function getOptionCropper(ratio, x, y, width, height, zoom, isCoverLocal) {

      var options = {
        //aspectRatio: ratio,
        minContainerHeight: 300,
        minContainerWidth: 360,
        //viewMode: 1,
        cropmove: function(e) {
          single ? imageSingle.isChange = true : isCover ? imageCover.isChange = true : imageBg.isChange = true;
        },
        crop: function (e) {
          if(single) {
            imageSingle.cropArea = e;
            var canvasData = imageSingle.$image.cropper('getCroppedCanvas', {fillColor: '#ffffff'});
            $(imgPreviewSingle).empty();
            $(imgPreviewSingle).append(createImageDom($(imgPreviewSingle).width(), $(imgPreviewSingle).height(),canvasData.width, canvasData.height, canvasData.toDataURL('image/jpeg')));
          } else if(isCoverLocal) {
            imageCover.cropArea = e;
            var canvasData = imageCover.$image.cropper('getCroppedCanvas', {fillColor: '#ffffff'});
            $(imgPreviewCover).empty();
            $(imgPreviewCover).append(createImageDom($(imgPreviewCover).width(), $(imgPreviewCover).height(),canvasData.width, canvasData.height, canvasData.toDataURL('image/jpeg')));
          } else {
            imageBg.cropArea = e;
            var canvasData = imageBg.$image.cropper('getCroppedCanvas', {fillColor: '#ffffff'});
            $(imgPreviewBackground).empty();
            $(imgPreviewBackground).append(createImageDom($(imgPreviewBackground).width(), $(imgPreviewBackground).height(),canvasData.width, canvasData.height, canvasData.toDataURL('image/jpeg')));
          }
        },
        zoom: function(e) {
          var image = $(this).cropper('getImageData');
          var ratio = (oriImage.width - image.width) / image.width;
          if(ratio !== 0) single ? imageSingle.zoom = ratio : isCover ? imageCover.zoom = ratio : imageBg.zoom = ratio;
        },
        built: function(e) {
          oriImage = Object.assign({}, $(this).cropper('getImageData'));
          $(this).cropper('zoom', zoom ? -zoom : 0);
          $(this).cropper('crop');
          loadImage();
          setCropBox();
        }
      };
      if(x === null || y === null || width === null || height === null) {
        options.autoCropArea = 0.8;
      } else {
        options.data = {
          left: Math.round(x),
          top: Math.round(y),
          width: Math.round(width),
          height: Math.round(height)
        }
      }
      return options;
    }

    function saveSingleImage() {
      var boxData = imageSingle.$image.cropper('getCropBoxData');
      return {
        picture: {
          specification: {
            crop_x: imageSingle.cropArea.x,
            crop_y: imageSingle.cropArea.y,
            width: imageSingle.cropArea.width,
            height: imageSingle.cropArea.height,
            zoom: imageSingle.zoom,
            cropBox_x: boxData.left,
            cropBox_y: boxData.top,
            cropBox_width: boxData.width,
            cropBox_height: boxData.height,
          }
        }
      }
    }

    function saveDoubleImage(data) {
      var boxDataCover = imageCover.$image.cropper('getCropBoxData');
      var boxDataBg = imageBg.$image.cropper('getCropBoxData');
      var cropAreaCover = imageCover.isChange ? imageCover.cropArea : imageCover.data;
      var cropAreaBg = imageBg.isChange ? imageBg.cropArea : imageBg.data;
      return {
        cover_image: {
          specification: {
            crop_x: cropAreaCover['x'],
            crop_y: cropAreaCover['y'],
            width: cropAreaCover['width'],
            height: cropAreaCover['height'],
            zoom: imageCover.zoom,
            cropBox_x: boxDataCover.left,
            cropBox_y: boxDataCover.top,
            cropBox_width: boxDataCover.width,
            cropBox_height: boxDataCover.height,
          }
        },
        background_image: {
          specification: {
            crop_x: cropAreaBg['x'],
            crop_y: cropAreaBg['y'],
            width: cropAreaBg['width'],
            height: cropAreaBg['height'],
            zoom: imageBg.zoom,
            cropBox_x: boxDataBg.left,
            cropBox_y: boxDataBg.top,
            cropBox_width: boxDataBg.width,
            cropBox_height: boxDataBg.height,
          }
        }
      }
    }

    function singleCropper(_$image) {
      $('.container-edit-profile').prepend('<div class="img-container"></div>');
      $('.img-container').append(_$image);

      imageSingle.$image = $('#myModal .img-container img').attr('id', 'image');
      // Cropper
      imageSingle.data = {};
      imageSingle.data.cropBoxX = _$image.attr('data-cropboxx');
      imageSingle.data.cropBoxY = _$image.attr('data-cropboxy');
      imageSingle.data.cropBoxWidth = _$image.attr('data-cropboxwidth');
      imageSingle.data.cropBoxHeight = _$image.attr('data-cropboxheight');

      imageSingle.zoom = _$image.attr('data-zoom') ? _$image.attr('data-zoom') : 0;
      imageSingle.options = getOptionCropper(getDataPro(_$image.attr('data-proportions')), _$image.attr('data-x'), _$image.attr('data-y'), _$image.attr('data-width'), _$image.attr('data-height'), imageSingle.zoom, null);
      //imageSingle.options.preview = '.img-preview';
      imageSingle.$image.on().cropper(imageSingle.options);
    }

    function doubleCropper(_$image) {
      imageBg.data = JSON.parse(_$image.attr('data-background'));
      imageBg.$image = $('<img class="image-cover">');
      imageBg.$image.attr('src', imageBg.data.original_picture_url);
      imageCover.data = JSON.parse(_$image.attr('data-cover'));
      imageCover.$image = $('<img class="image-background">');
      imageCover.$image.attr('src', imageCover.data.original_picture_url);

      imageBg.zoom = imageBg.data.zoom ? imageBg.data.zoom : 0;
      imageBg.options = getOptionCropper(getDataPro(imageBg.data.proportions), imageBg.data.x, imageBg.data.y, imageBg.data.width, imageBg.data.height, imageBg.data.zoom, false);
      //imageBg.options.preview = '.img-preview-background';
      imageCover.zoom = imageCover.data.zoom ? imageCover.data.zoom : 0;
      imageCover.options = getOptionCropper(getDataPro(imageCover.data.proportions), imageCover.data.x, imageCover.data.y, imageCover.data.width, imageCover.data.height, imageCover.data.zoom, true);
      //imageCover.options.preview = '.img-preview-cover';
      //Background
      imageBg.$image.on().cropper(imageBg.options);

      $('.container-edit-profile').prepend('<div class="img-container-background hide"></div>');
      $('.img-container-background').append(imageBg.$image);
      //Cover
      imageCover.$image.on().cropper(imageCover.options);

      $('.container-edit-profile').prepend('<div class="img-container-cover"></div>');
      $('.img-container-cover').append(imageCover.$image);
    }

    function cancelSingleImage() {
      imageSingle.$image.on().cropper("destroy");
      $('#myModal .img-container').remove();
    }

    function loadImage() {
      if(single) {
        var imageSingleImg = new Image();
        imageSingleImg.onload = function() {
          $(imgPreviewSingle).empty();
          $(imgPreviewSingle).append(createImageDom($(imgPreviewSingle).width(), $(imgPreviewSingle).height(), imageSingleImg.width, imageSingleImg.height, urlSingleCrop));
        };
        imageSingleImg.src = urlSingleCrop;
      } else {
        var imageBgImg = new Image();
        imageBgImg.onload = function() {
          $(imgPreviewBackground).empty();
          $(imgPreviewBackground).append(createImageDom($(imgPreviewBackground).width(), $(imgPreviewBackground).height(), imageBgImg.width, imageBgImg.height, urlBgCrop));
        };
        imageBgImg.src = urlBgCrop;

        var imageCoverImg = new Image();
        imageCoverImg.onload = function() {
          $(imgPreviewCover).empty();
          $(imgPreviewCover).append(createImageDom($(imgPreviewCover).width(), $(imgPreviewCover).height(), imageCoverImg.width, imageCoverImg.height, urlCoverCrop));
        };
        imageCoverImg.src = urlCoverCrop;
      }
    }

    function cancelDoubleImage() {
      imageBg.$image.on().cropper("destroy");
      $('#myModal .img-container-background').remove();
      imageCover.$image.on().cropper("destroy");
      $('#myModal .img-container-cover').remove();
      $('.img-preview-background').empty();
      $('.img-preview-cover').empty();
    }

    function reset() {
      $('#myModal').addClass('hide');
      $('.review-phone-' + typeCropper).addClass('hide');
      typeCropper = 'avatar';
      $('.pull-right img').remove();
      $('#background').removeClass('active');
      $('#cover').addClass('active');
      imageBg = {}; imageSingle = {}; imageCover = {}; oriImage = {}; urlSingleCrop = {};
      url = {}; urlBgCrop = {}; urlCoverCrop = {}; imgPreviewBackground = {}; imgPreviewCover = {}; imgPreviewSingle = {};
      single = true; isCover = true;
    }

    function swap(isCoverFlag) {
      isCover = isCoverFlag;
      if(isCover) {
        $('.img-container-cover').removeClass('hide');
        $('.img-container-background').addClass('hide');
      } else {
        $('.img-container-background').removeClass('hide');
        $('.img-container-cover').addClass('hide');
      }
    }

    function createImageDom(widthBox, heightBox, width, height, data) {
      if (height === 0) {
          // Default empty image src to hide the grey border
          data = 'data:image/png;base64,R0lGODlhFAAUAIAAAP///wAAACH5BAEAAAAALAAAAAAUABQAAAIRhI+py+0Po5y02ouz3rz7rxUAOw=='
      }
      if(width <= widthBox && height <= heightBox) {
        return '<img src=' + data + '>';
      } else {
        var ratio  = width / height;
        var newWidth = 0;
        var newHeight = 0;
        if (width > height) {
          newWidth = widthBox;
          newHeight = newWidth / ratio;
        } else {
          newHeight = heightBox;
          newWidth = newHeight * ratio;
        }
        var marginLeft = (widthBox - newWidth) / 2;
        var marginTop = (heightBox - newHeight) / 2;
        return '<img src=' + data + ' height=' + newHeight + ' width=' + newWidth + ' style="margin-left:' + marginLeft + 'px;margin-top:' + marginTop + 'px;">';
      }
    }

    function setCropBox() {
      if(single) {
        if(imageSingle.data.cropBoxX !== null) {
          imageSingle.$image.cropper('setCropBoxData', {
            left: parseInt(imageSingle.data.cropBoxX),
            top: parseInt(imageSingle.data.cropBoxY),
            width: parseInt(imageSingle.data.cropBoxWidth),
            height: parseInt(imageSingle.data.cropBoxHeight),
          });
        }
      } else {
        if(imageBg.data.cropBoxX !== null) {
          imageBg.$image.cropper('setCropBoxData', {
            left: parseInt(imageBg.data.cropBoxX),
            top: parseInt(imageBg.data.cropBoxY),
            width: parseInt(imageBg.data.cropBoxWidth),
            height: parseInt(imageBg.data.cropBoxHeight),
          });
        }
        if(imageCover.$image.cropBoxX !== null) {
          imageCover.$image.cropper('setCropBoxData', {
            left: parseInt(imageCover.data.cropBoxX),
            top: parseInt(imageCover.data.cropBoxY),
            width: parseInt(imageCover.data.cropBoxWidth),
            height: parseInt(imageCover.data.cropBoxHeight),
          });
        }
      }
    }
});
