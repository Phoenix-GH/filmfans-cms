class RadioButtonsInlineInput < SimpleForm::Inputs::CollectionRadioButtonsInput
  # http://kb.maxivak.com/index.php?title=Rails-forms#inline_radio_buttons
  def input(wrapper_options)
    label_method, value_method = detect_collection_methods
    @builder.send("collection_radio_buttons", attribute_name, collection, value_method,
                  label_method, input_options, input_html_options,
                  &collection_block_for_nested_boolean_style)
  end

  protected
  def item_wrapper_class
    "radio-inline"
  end
end