$(function(){
    Handlebars.registerHelper('classForWidth', function(width, half_klass, full_klass) {
        return width == 'half' ? half_klass : full_klass;
    });

    Handlebars.registerHelper('fallbackBgClass', function(bg) {
        return bg ? '' : 'media-box-img-container--blank';
    });

    $('.js-mp-emulator').each(function(){
        var $emulator = $(this);
        $emulator.on('refresh', refresh);
        var $screen = $emulator.find('.js-mp-emulator__screen');

        function refresh(event){
            var elements = _.rest(arguments);
            $screen.html('');
            _(elements).each(function(element){
                var template = element.template;
                var vars = element.vars || {};
                var html = _.isFunction(HandlebarsTemplates[template]) ? HandlebarsTemplates[template](vars) : '';
                $screen.append(html);
            });
        }
    });

    $('.js-mp-elements-container').each(function(){
        var $container = $(this);
        $container.sortable({
            handle: '.js-sort-handle',
            placeholder: 'sortable-placeholder'
        }).bind('sortupdate', updatePreview);

        $container.on('collection:newElement', function(e){
            fillDataAttributes($(e.target));
            updatePreview();
        });

        $container.on('member:removed', updatePreview);
        function updatePreview(){
            var $elements_container = $container;
            var $emulator = $($elements_container.data('emulator'));
            var elements_attrs = collect_elements_attrs($elements_container);
            update_positions($elements_container);
            $emulator.trigger('refresh', elements_attrs);
            if($('#mobile_preview').find('.same-type').length !== 0) sort_element_by_type();
        }


        $container.on('change', '.js-container-type', function(e){
            var $element = $(e.currentTarget).closest('.js-mp-element');
            clearDataVars($element);
            fillDataTemplate($element);
            updatePreview();
        });

        $container.on('change', '.js-container-name', function(e){
            fillDataVars($(e.currentTarget).closest('.js-mp-element'));
            updatePreview();
        });

        $container.on('change', '.js-container-width', function(e){
            fillDataWidth($(e.currentTarget).closest('.js-mp-element'));
            updatePreview();
        });

        $container.find('.js-mp-element').each(function(idx, element){
            var $element = $(element);
            fillDataAttributes($element);
        });
        updatePreview();
    });

    function fillDataTemplate($element) {
        var $select = $element.find('.js-container-type');
        var template_name = 'mobile_previews/'+$select.val().toLowerCase()+'_container';
        $element.data('template', template_name);
    }

    function fillDataWidth($element){
        var $checkbox  = $element.find('.js-container-width');
        var width = $checkbox.is(':checked') ? 'full' : 'half';
        $element.data('varWidth', width);
    }

    function fillDataVars($element){
        var $select = $element.find('.js-container-name');
        var description = 'lipsum';
        var title = $select.data('title');
        var image_url = $select.data('picture');
        var images_urls = $select.data('pictures');
        var product_available = ($select.data('productAvailable') === false) ? false : true;

        $element.data('varTitle', title);
        $element.data('varDescription', description);
        $element.data('varImageUrl', image_url);
        $element.data('varImagesUrls', images_urls);
        $element.data('varProductAvailable', product_available);
    }

    function fillDataAttributes($element){
        fillDataTemplate($element);
        fillDataWidth($element);
        fillDataVars($element);
    }

    function clearDataVars($element){
        $element.data('varTitle', null);
        $element.data('varDescription', null);
        $element.data('varImageUrl', null);
    }

    function collect_elements_attrs($elements_container){
        var elements_attrs = $elements_container.find('.js-mp-element:visible').map(function(idx, element){
            var $element = $(element);
            return {
                template: $element.data('template'),
                vars: template_vars($element)
            };
        });
        return elements_attrs;

    }

    function update_positions($elements_container){
        $elements_container.find('.js-mp-element').each(function(idx){
            var $element = $(this);
            $element.find('.js-sort-position').val(idx);
        });
    }


    function template_vars($element){
        return _($element.data()).pick(function(value, key){
                return /^var[A-Z]/.test(key);
            });
    }

    function sort_element_by_type() {
      var $myContainer = $('.js-mp-emulator__screen').children();

      var type = ['product', 'media', 'media-owner', 'media-owner-trending', 'magazine', 'tvshow', 'event', 'products', 'channel', 'movie'];
      var object = {};
      for(var i = 0; i < $myContainer.length; i++) {
        for(var j = 0; j < type.length; j++) {
          if($($myContainer[i]).find('div.media-box--' + type[j]).length !== 0) {
            if(!object[type[j]]) object[type[j]] = [];
            object[type[j]].push($myContainer[i]);
          }
        }
      }

      $('.js-mp-emulator__screen').empty();
      for(key in object) {
        $('.js-mp-emulator__screen').append('<div class="row clearfix box-' + key + '"></div>');
        $('.js-mp-emulator__screen .box-' + key).append(object[key]);
      }
    }
});
