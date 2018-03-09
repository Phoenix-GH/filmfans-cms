$(function() {
  var $img = $('.image-with-tags');
  var options = {
    edit: true,
    align: {
      y: 'bottom'
    },
    offset: {
      top: -35
    }
  };

  var data = app.vars.mediaContainerTags;
  var taggd = $img.taggd(options, data);

  $('#add-all-tags').click(function() {
    var mediaContainerId = app.vars.mediaContainerId;
    var updatedTagsHash = taggd.data;

    $.ajax({
      url: '/panel/media_containers/' + mediaContainerId + '/tags',
      data: { tags: updatedTagsHash },
      method: 'post',
      success: function() {
        location.href = '/panel/media_containers/' + mediaContainerId;
      },
      error: function() {
        $('#tags-alert').empty().append('Error occured while saving tags');
      }
    });
  });
});
