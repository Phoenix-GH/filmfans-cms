class OptionValueSerializer
  def initialize(option_value)
    @option_value = option_value
  end

  def results
    return '' unless @option_value

    generate_option_value_json
  end

  private
  def generate_option_value_json
    {
        value: 'ONESIZE' == @option_value.name.to_s ? 'One size' : @option_value.name.to_s,
        option_type: option_type
    }
  end

  def option_type
    return '' unless @option_value.option_type

    @option_value.option_type.name.to_s
  end
end
