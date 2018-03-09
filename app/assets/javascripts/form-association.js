$(document).on('click', '.add-link-association', function() {
    var association = $(this).data('association');
    var content = $(this).data('content');
    var newId = new Date().getTime();
    var regexp = new RegExp('new_' + association, 'g');
    $(this).before(content.replace(regexp, newId));
});
