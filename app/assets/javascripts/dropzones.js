$(function () {
  Dropzone.options.mediaContainerForm = { // The camelized version of the ID of the form element
    url: '/json/media_contents',
    maxFilesize: 700,
    addRemoveLinks: true,
    acceptedFiles: ".jpeg,.jpg,.png,.gif,.mov,.avi,.mp4,.mkv,.wmv,.mpg",
    maxFiles: 1,
    // images will be cropped if enable this feature. Instead of letting this library create thumbnail from
    // the local picture file (which will be cropped), we wait a while and display the thumbnail created
    // from server side (see "response.thumb_url" below)
    createImageThumbnails: false,
    success: function(file, response) {
      $(file.previewElement).find('.dz-remove').attr('id', response.media_content_id);
      $(file.previewElement).addClass('dz-success');
      $(file.previewElement).find('img').attr('src', response.thumb_url);

      $('#media_content_id').val(response.media_content_id)
    },
    error: function(file, response) {
      $(file.previewElement).addClass('dz-error');
      errorElement = file.previewElement.querySelector("[data-dz-errormessage]");
      return errorElement.textContent = response;
    },
    removedfile: function(file) {
      var id = $(file.previewTemplate).find('.dz-remove').attr('id');

      $.ajax({
        type: 'DELETE',
        url: "/json/media_contents/" + id
      });

      $('#media_container_form_media_content_id').val('')
      var previewElement;
      return (previewElement = file.previewElement) != null ? (previewElement.parentNode.removeChild(file.previewElement)) : (void 0);
    },
    init: function() {
      if(app.vars.mediaContent !== undefined) {
        var content = app.vars.mediaContent;
        this.emit("addedfile", content);
        this.emit("thumbnail", content, content.src);
        this.emit("complete", content);
        this.files.push(content);
        $(content._removeLink).attr("id", content.id);
        $('#media_content_id').val(content.id)
      }

      this.on('addedfile', function(file) {
        if (this.files.length > 1) {
          this.removeFile(this.files[0]);
        }
      });
    }
  };

  Dropzone.options.productForm = { // The camelized version of the ID of the form element
    url: '/json/product_files',
    maxFilesize: 700,
    addRemoveLinks: true,
    acceptedFiles: ".jpeg,.jpg,.png,.gif,.mov,.avi,.mp4,.mkv,.wmv,.mpg",
    maxFiles: 1,
    createImageThumbnails: false,
    success: function(file, response) {
      $(file.previewElement).find('.dz-remove').attr('id', response.product_file_id);
      $(file.previewElement).addClass('dz-success');
      $(file.previewElement).find('img').attr('src', response.thumb_url);

      $('#product_file_id').val(response.product_file_id)
    },
    error: function(file, response) {
      $(file.previewElement).addClass('dz-error');
      errorElement = file.previewElement.querySelector("[data-dz-errormessage]");
      return errorElement.textContent = response;
    },
    removedfile: function(file) {
      var id = $(file.previewTemplate).find('.dz-remove').attr('id');

      $.ajax({
        type: 'DELETE',
        url: "/json/product_files/" + id
      });

      $('#product_form_product_file_id').val('')
      var previewElement;
      return (previewElement = file.previewElement) != null ? (previewElement.parentNode.removeChild(file.previewElement)) : (void 0);
    },
    init: function() {
      if(app.vars.productFile !== undefined) {
        var content = app.vars.productFile;
        this.emit("addedfile", content);
        this.emit("thumbnail", content, content.src);
        this.emit("complete", content);
        this.files.push(content);
        $(content._removeLink).attr("id", content.id);
        $('#product_file_id').val(content.id)
      }

      this.on('addedfile', function(file) {
        if (this.files.length > 1) {
          this.removeFile(this.files[0]);
        }
      });
    }
  };

  $(document).on('collection:newElement','.product-variants',  function(e){
      var $variant = $(e.target);
      initialize_variant_dropzone($variant);

  });
  $('#variants > .content-container').each(function(){
      var $variant = $(this);
      initialize_variant_dropzone($variant);

  });
  Dropzone.options.productVariantFormDropzone = false;
  function initialize_variant_dropzone($variant){
      console.log($variant);
      var $dropzone = $variant.find('.dropzone');
      var $image_ids_input = $variant.find('[name*=temp_image_ids]');
      var image_ids = [];
      $dropzone.dropzone({
          url: '/json/temp_images',
          maxFilesize: 700,
          addRemoveLinks: true,
          acceptedFiles: ".jpeg,.jpg,.png",
          paramName: 'image',
          maxFiles: 10,
          createImageThumbnails: false,
          success: function(file, response) {
              $(file.previewElement).find('.dz-remove').attr('id', response.temp_image_id);
              $(file.previewElement).addClass('dz-success');
              $(file.previewElement).find('img').attr('src', response.thumb_url);

              if(image_ids.indexOf(response.temp_image_id) < 0){
                  image_ids.push(response.temp_image_id);
              }
              $image_ids_input.val(image_ids.join(','))
          },
          error: function(file, response) {
              $(file.previewElement).addClass('dz-error');
              errorElement = file.previewElement.querySelector("[data-dz-errormessage]");
              return errorElement.textContent = response;
          },
          removedfile: function(file) {
              var id = $(file.previewTemplate).find('.dz-remove').attr('id');

              $.ajax({
                  type: 'DELETE',
                  url: "/json/temp_images/" + id
              });
              var index = image_ids.indexOf(parseInt(id));
              if( index > -1){
                  image_ids.splice(index, 1);
              }
              $image_ids_input.val(image_ids.join(','));
              var previewElement;
              return (previewElement = file.previewElement) != null ? (previewElement.parentNode.removeChild(file.previewElement)) : (void 0);
          },
          init: function() {
              if($image_ids_input.data('images') !== undefined) {
                  var that = this;
                  _($image_ids_input.data('images')).each(function(content){
                      that.emit("addedfile", content);
                      that.emit("thumbnail", content, content.thumb_url);
                      that.emit("complete", content);
                      that.files.push(content);
                      $(content._removeLink).attr("id", content.temp_image_id);
                      $('#product_file_id').val(content.temp_image_id);
                      image_ids.push(content.temp_image_id);
                  });

              }
          }
      });
  }
});
