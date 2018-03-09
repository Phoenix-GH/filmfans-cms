modulejs.define('magazine-issues/commons', function(ImageGallery) {
    return {
        getIssueJsonUrl: function(action) {
        return '/json/issues/' + $('#_issue___id').val() + '/' + action;
        },

        onAjaxError: function(jqXHR, textStatus, errorThrown) {
            console.error(jqXHR);
            HotSpottingUtils.showError('An error has occurred while trying to fulfill your request! ' +
                'Please contact the system administrator for support');
        }
    };
});
