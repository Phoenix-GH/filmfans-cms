$(function () {
    var $page = $('.manual_training_detail');
    if (!$page.length) {
        return;
    }

    $page.find('.trained-user-images').on('click', '.product .fa-close', function(e) {
        deleteUserImage($(e.currentTarget));
    });

    function deleteUserImage($userImage) {
        $.ajax({
            url: '/panel/manual_trainings/' + $userImage.attr('training-id') + '/train_user_image',
            method: 'DELETE',
            data: JSON.stringify({image_id: $userImage.attr('data-id')}),
            processData: false,
            dataType: "html",
            contentType: "application/json"
        })
            .done(function() {
                $userImage.parent().remove();
            })
            .fail(function(jqXHR, textStatus, errorThrown) {
                console.error(jqXHR);
            });
    }
});