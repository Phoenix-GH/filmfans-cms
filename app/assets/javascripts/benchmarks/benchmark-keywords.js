$(function () {
    var $containers = $('.benchmark-keywords');
    if (!$containers.length) {
        return;
    }

    $containers.each(function(index, container) {
        var $container = $(container);
        var image_url = $container.data('image-url');

        $.ajax({
            url: '/json/benchmarks/keywords?image_url=' + image_url,
            method: 'GET'
        }).success(function(response) {
            $container.html('<tr><td><b>' + response.source + '</b></td></tr>');
            if (response.message) {
                $container.append('<tr><td>' + response.message + '</td></tr>');
            } else {
                var keywords_html = [];
                _.each(response.keywords, function(keyword) {
                    keywords_html.push(keyword.name + ' (' + keyword.score.toFixed(2) + ')')
                });
                $container.append('<tr><td>' + keywords_html.join('<br/>') + '</td></tr>');
            }
        }).fail(function() {
            $container.html('<tr><td>Request failed</td></tr>');
        });
    });
});