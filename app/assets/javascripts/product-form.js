$(function() {
    $('.add-size').click(function() {
        var $variant_attributes = $(".variant_attributes");
        var $template = $(".variant_attributes .row").first().clone();
        var clone = $template.clone();
        clone.appendTo($variant_attributes);
    });
});
$('.add_link').click(function() {
    var association = $(this).data('association');
    var content = $(this).data('content');
    var newId = new Date().getTime();
    var regexp = new RegExp('new_' + association, 'g');
    $(this).before(content.replace(regexp, newId));
});
