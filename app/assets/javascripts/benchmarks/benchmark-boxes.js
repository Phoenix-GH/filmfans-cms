$(function () {
    var $container = $('.user_photo .origin-photo');
    if (!$container.length) {
        return;
    }

    function draw_boxes(scaleX, scaleY) {
        var sub_results = $container.data('subResults');
        for (var i = 0; i < sub_results.length; i++) {
            var box = sub_results[i].box;
            var anchor = sub_results[i].anchor;

            box.x = box.x * scaleX;
            box.y = box.y * scaleY;
            box.width = box.width * scaleX;
            box.height = box.height * scaleY;

            anchor.x = anchor.x * scaleX;
            anchor.y = anchor.y * scaleY;

            $container.append([
                '<div class="box" data-box="',
                i + '"',
                ' style="top: ',
                box.y + 'px',
                '; left: ',
                box.x + 'px',
                '; width: ',
                box.width + 'px',
                '; height: ',
                box.height + 'px',
                '"></div>'
            ].join(''));

            $container.append([
                '<a href="#" class="anchor" data-box="',
                i + '"',
                ' style="top: ',
                (anchor.y - 5) + 'px',
                '; left: ',
                (anchor.x - 5) + 'px',
                '; width: 10px',
                '; height: 10px',
                '"></>'
            ].join(''));
        }
    }

    $container.find('img').imagesLoaded(function() {
        var $image = $container.find('img');
        if ($image.length) {
            var scaleX = $image.innerWidth() / $image[0].naturalWidth;
            var scaleY = $image.innerHeight() / $image[0].naturalHeight;
            draw_boxes(scaleX, scaleY);
        }
    });

    $container.on('click', '.anchor', function(e) {
        e.preventDefault();
        var boxId = $(this).data('box');
        $container.find('.box').removeClass('selected');
        $container.find('.box[data-box=' + boxId + ']').addClass('selected');
    });
});