$(function() {
  var mediaOwnerTabs = {
    $tabs: $('.tabs-container'),
    $selectArea: $('.media-owner-container-select'),
    makeTabActive: function(event) {
      event.preventDefault();
      $(this).closest('.tabs-container').find('a').removeClass('active');
      $(this).addClass('active');
      $(this).closest('.tabs-container').find('.col-md-12').removeClass('current');
      $(this).closest('.tabs-container').find($(this).data('owner')).addClass('current');
    },
    selectCheckbox: function() {
      $(this).find('input').prop('checked') ?
        $(this).removeClass('checked')
               .find('input').prop('checked', false) :
        $(this).addClass('checked')
               .find('input').prop('checked', true);
    },
    init: function() {
      this.$tabs.on('click', 'a', this.makeTabActive);
      this.$selectArea.on('click', '.media-owner', this.selectCheckbox);
    }
  };
  $(document).ready(function() {
    mediaOwnerTabs.init();
  });
});
