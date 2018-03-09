$(function () {
    $container = $('.social-account-followings');
    if (!$container.length) {
        return;
    }

    var hash = window.location.hash;
    if (hash) {
        var $currentItem = $container.find('tr' + hash);
        if ($currentItem.length > 0) {
            $currentItem.css({backgroundColor: '#e6e6e6'});
            setTimeout(function() {
                $currentItem.css({backgroundColor: 'transparent'});
            }, 3000);
        }
    }
});