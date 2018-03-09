describe Panel::ToggleActiveAdminService do
  it 'activate' do
    admin = create(:admin, active: false)

    service = Panel::ToggleActiveAdminService.new(admin)
    service.call
    expect(admin.reload.active).to eq(true)
  end

  it 'inactivate' do
    admin = create(:admin, active: true)

    service = Panel::ToggleActiveAdminService.new(admin)
    service.call
    expect(admin.reload.active).to eq(false)
  end
end
