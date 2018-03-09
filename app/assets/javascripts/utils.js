var HotSpottingUtils = (function (Utils, $) {

    Utils.showInlineWaiting = function($container, message, noEscapse) {
        $container.find('.inline-waiting-indicator').remove();
        $container.prepend(
            HandlebarsTemplates['core/inline-waiting-indicator']({
                message: message || 'Working...',
                noEscapse: noEscapse
            }));
    };
    Utils.hideInlineWaiting = function($container) {
        $container.find('.inline-waiting-indicator').remove();
    };

    Utils.showBlockWaiting = function($container, message, noEscapse) {
        $container.css('pointer-events', 'none');
        $container.find('.block-waiting-indicator').remove();
        $container.prepend(
            HandlebarsTemplates['core/block-waiting-indicator']({
                message: message || 'Working...',
                noEscapse: noEscapse
            })
        );
    };

    Utils.hideBlockWaiting = function($container) {
        $container.find('.block-waiting-indicator').remove();
        $container.css('pointer-events', 'auto');
    };

    Utils.showError = function(message) {
        var partial = HandlebarsTemplates['core/error_message']({message: message});
        var container = $('.alerts-container-local');
        container = container.length ? container : $('.alerts-container-global');
        container.empty().append(partial);
    };

    Utils.confirm = function(message, onConfirm, onCancel) {
        var partial = HandlebarsTemplates['core/confirm-modal-dialog']({message: message});
        $('#confirm-js').remove();
        $('body').append(partial);

        $('#confirm-js').modal({ backdrop: 'static', keyboard: false })
            .one('click', '.btn-confirm', function() {
                if (onConfirm) {
                    onConfirm();
                }
            })
            .one('click', '.btn-cancel', function() {
                if (onCancel) {
                    onCancel();
                }
            });
    };

    Utils.errorModal = function(message, onOK) {
        var partial = HandlebarsTemplates['core/error-modal-dialog']({message: message});
        $('#error-js').remove();
        $('body').append(partial);

        $('#error-js').modal({ backdrop: 'static', keyboard: false })
            .one('click', '.btn-error-ok', function() {
                if (onOK) {
                    onOK();
                }
            });
    };
    
    /**
     * this supports the following construct
     * {{#ifCond remaining '>' 1}} ... {{else}} ... {{/ifCond}}
     */
    Utils.registerHandlebarsCompareHelper = function () {
        Handlebars.registerHelper('ifCond', function (v1, operator, v2, options) {

            switch (operator) {
                case '==':
                    return (v1 == v2) ? options.fn(this) : options.inverse(this);
                case '===':
                    return (v1 === v2) ? options.fn(this) : options.inverse(this);
                case '<':
                    return (v1 < v2) ? options.fn(this) : options.inverse(this);
                case '<=':
                    return (v1 <= v2) ? options.fn(this) : options.inverse(this);
                case '>':
                    return (v1 > v2) ? options.fn(this) : options.inverse(this);
                case '>=':
                    return (v1 >= v2) ? options.fn(this) : options.inverse(this);
                case '&&':
                    return (v1 && v2) ? options.fn(this) : options.inverse(this);
                case '||':
                    return (v1 || v2) ? options.fn(this) : options.inverse(this);
                default:
                    return options.inverse(this);
            }
        });
    };

    return Utils;
}(HotSpottingUtils || {}, jQuery));