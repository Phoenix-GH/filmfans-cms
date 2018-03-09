$(function () {
    var $wrapper = $('.benchmark-thresholds');
    if (!$wrapper.length) {
        return;
    }

    function update_threshold($item) {
        var current_val = $item.val();
        var data = {
            name: $item.attr('name'),
            value: current_val
        };

        $.ajax({
            url: '/json/benchmarks/update_threshold',
            dataType: "json",
            contentType: "application/json",
            method: 'POST',
            data: JSON.stringify(data),
            success: function (data) {
                if (!data.name) {
                    $item.val(current_val);
                }
            },
            error: function(xhr, status, error) {
                $item.val(current_val);
            }
        });
    }

    $wrapper.on('blur', 'input', function(e) {
        update_threshold($(this));
    });

    $wrapper.on('keydown', 'input', function(e) {
        if (e.keyCode === 13) {
            update_threshold($(this));
        }
    });
});