$(function () {
    $(document).on('change', '.js-container-type', function () {
        var selector = $(this).parents('.container-box').find('.js-container-name');
        selector.val('');
        addSelect2ToContainerNameSelector(selector)
    });

    $(document).on('click', '.add_link', function () {
        addSelect2ToContainerTypeSelector('.js-container-type:last');
        addSelect2ToContainerNameSelector('.js-container-name:last');
    });

    $('.js-container-type').each(function () {
        addSelect2ToContainerTypeSelector(this)
    });
    $('.js-container-name').each(function () {
        addSelect2ToContainerNameSelector(this)
    })
});

var addSelect2ToContainerTypeSelector = function (selector) {
    $(selector).select2({
        minimumResultsForSearch: -1,
        theme: 'bootstrap hot-select2 hot-select2-type'
    });
};

var addSelect2ToContainerNameSelector = function (selector) {
    $(selector).select2({
        theme: 'bootstrap hot-select2 hot-select2-name',
        ajax: {
            url: searchTypeUrl($(selector)),
            dataType: 'json',
            delay: 250,
            data: function (params) {
                return {
                    search: params.term,
                    channel_id: app.vars.channelId
                };
            },
            processResults: function (data, params) {
                return {results: data};
            }
        },
        minimumInputLength: 2,
        templateResult: function (data) {
            return $(
                "<div class='hot-select2-name-container'>" +
                (data.thumb ? "<img src='" + data.thumb + "'/>" : '') +
                "<span>" + data.name + "</span>" +
                "</div>"
            );
        },
        templateSelection: function (selected) {
            if (selected.name) {
                $(selector).data('picture', selected.thumb);
                $(selector).data('pictures', selected.thumbs);
                $(selector).data('title', selected.name);
                $(selector).data('productAvailable', selected.available);
                return $(
                    "<div class='hot-select2-name-container'>" +
                    "<span>" + selected.name + "</span>" +
                    "</div>"
                );
            } else {
                return $(
                    "<div class='hot-select2-name-container'>" +
                    "<span>" + selected.text + "</span>" +
                    "</div>"
                );
            }
        }
    });
};

var searchTypeUrl = function (selector) {
    var type = selector.parents('.container-box').find('.js-container-type').val();
    var width_element = selector.parents('.container-box').find('.js-container-width');
    if (type == 'Product') {
        $(width_element).attr('checked', false);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/products"
    } else if (type == 'MediaContainer') {
        $(width_element).attr('disabled', false);
        $(width_element).change();
        return "/json/media_containers"
    } else if (type == "MediaOwner") {
        $(width_element).attr('checked', false);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/media_owners"
    } else if (type == "Magazine") {
        //$(width_element).attr('checked', false);
        $(width_element).attr('disabled', false);
        $(width_element).change();
        return "/json/magazines"
    } else if (type == "TvShow") {
        //$(width_element).attr('checked', false);
        $(width_element).attr('disabled', false);
        $(width_element).change();
        return "/json/tv_shows"
    } else if (type == "Event") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/events"
    } else if (type == "EventsContainer") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/events_containers"
    } else if (type == "ManualPostContainer") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/media_owner_trending_containers"
    } else if (type == "Channel") {
        $(width_element).attr('checked', false);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/channels"
    } else if (type == "CollectionsContainer") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/collections_containers"
    } else if (type == "ProductsContainer") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/products_containers"
    } else if (type == "MoviesContainer") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/movies_containers"
    } else if (type == "Movie") {
        $(width_element).attr('checked', true);
        $(width_element).attr('disabled', true);
        $(width_element).change();
        return "/json/movies"
    } else {
        console.warn('unhandled container type: ' + type);
    }
};
