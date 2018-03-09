(function ( $ ) {
  $.fn.i18n = function(options) {
    var settings = $.extend({
      // default no locales, and therefore the input must remain unchanged
      locales: [],
      // if no attribute option is given, this is the default
      attribute: 'data-field'
    }, options);

    var localesBackup = settings.locales;

    this.each(function(index, obj) {
      var localesData = $(obj).attr('data-i18n');
      var locales = localesData ? localesData.split(',') : settings.locales;
      var translationData = $(obj).attr('data-translation') || {};
      var translation = translationData ? JSON.parse(translationData) : {};
      var type = $(obj).attr('type');
      var objName = $(obj).attr('name');
      var formAttr = objName.substring(objName.lastIndexOf("[")+1, objName.length -1);

      // console.log(typeof(translation), translation);
      // console.log(JSON.stringify(translationData));
      // console.log(objName, formAttr);

      if (!locales.length || type != "text") {
        return;
      }

      $(obj).wrap('<span class="input-prepend input-append locale-wrapper">');

      for (i = locales.length - 1; i > 0; i--) {
        $(obj).before($(obj).clone());
      }

      for (i = locales.length - 1; i >= 0; i--) {
        $(obj).after('<a href="javascript:void(0)">' + locales[i] + '</a>' + '&nbsp&nbsp');
      }

      var $parent = $(obj).parent();
      var attrVal = $(obj).attr(settings.attribute);

      $parent.children('input').each(function(i, object) {
        if (i > 0) {
          $(object).css({display: "none"})
        }

        if (attrVal) {
          $(object).attr(settings.attribute, attrVal + '.' + settings.locales[i]);
        } else {
          $(object).attr(settings.attribute, settings.locales[i]);
        }

        var locale = locales[i];
        var localeVal = translation[locale];
        $(object).attr("data-i18n", locale);
        $(object).attr("value", localeVal || "");
        $(object).attr("name", $(object).attr("name") + "[" + locale + "]");
        // console.log(_.template("locale: <%= l %>, translation: <%= t %>")({l:locale, t:translation[locale][formAttr]}))
      });

      var updateStyle = function(activeIndex) {
        var $aElems = $parent.children('a');
        var $inputElems = $parent.children('input');
        $aElems.each(function(i, object) {
          var $coInput = $parent.children('input:nth-of-type(' + (i+1) + ')');
          var cls = [];
          if (_.isEmpty($coInput.val())) {
            cls.push("disabled");
          } else {
            cls.push("enabled");
          }
          if (i === activeIndex) {
            cls.push("active");
          } else {
            cls.push("inactive");
          }
          $(object).attr("class", cls.join(" "));
        });
      }

      var $aElems = $parent.children('a');
      $aElems.on('click', function(e) {
        var i = $aElems.index(this);
        var display = $parent.children('input:nth-of-type(' + (i+1) + ')').css('display');
        if(display == 'none'){
          $parent.children('input').animate({"width": "0"}, 200).promise().done(function () {
            $parent.children('input').hide();
            $parent.children('input:nth-of-type(' + (i+1) + ')').show().animate({"width": "100%"}, 200).focus();
            updateStyle(i);
          });
        }
      });

      updateStyle(0);
    });
    return this;
  };
}( jQuery ));

$(function () {
  $('.locale-text').i18n({});
})
