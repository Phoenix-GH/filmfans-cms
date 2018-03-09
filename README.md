# hotspotting

## Local environment setup
Refer to setup-dev-env-on-mac.sh

## Support translation for a field
1. Migrate the table to add translation json field. Something like.
   add_column :products_containers, :translation, :json, null: false, default: '{}'

2. In coresponding model class, add below code.
   include Translation
   translate :col_name1, :col_name2

3. Add the same above code to form. Now, the form has some attributes automatically - col_name_all_langs

4. To have input field with languages. Use this.
   f.input :name_all_langs, label: _('Product Container Name'), placeholder: "Don't fill this if you plan to select a category", input_html: {"class": "locale-text", data: {"i18n": supported_languages.join(","), "translation": @products_container ? @products_container.name_all_langs : {}}}

5. To get translation. Use.
   model.col_name_translation("<translation code>")

_Remember to modify the service to commit translation's values!__
