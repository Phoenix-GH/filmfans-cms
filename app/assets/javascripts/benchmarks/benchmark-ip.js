
$(function() {
    var $page = $('.benchmark-list, .benchmark-detail');
    if (!$page.length) {
        return;
    }

    $page.find('.ip-country').each(function() {
       var ip = $(this).find('.ip').text();
        if (ip && ip.trim() != '') {
            var that = this;
            $.getJSON("http://freegeoip.net/json/" + ip.trim(), function (data) {
                $(that).find('.country').append('<img src="http://www.geonames.org/flags/s/' + data.country_code.toLowerCase() + '.png">' + '<span class="value">' + data.country_name + '</span>');
            });
        }
    });
});
