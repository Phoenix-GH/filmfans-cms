class ProductUniquenessValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record_id = record.try(:id)

    if name_taken?(record_id, value)
      record.errors[attribute] << _('has already been taken.')
    end
  end

  private
  def name_taken?(record_id, new_name)
    old_product = Product.find_by(id: record_id)

    old_product.try(:name) != new_name &&
      Product.where('name iLIKE ?', new_name.strip).any?
  end
end
