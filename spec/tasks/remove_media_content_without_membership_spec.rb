describe RemoveMediaContentWithoutMembership do
  it 'remove withoout membership' do
    membership = create(:media_container)
    create(:media_content, membership: membership, created_at: Date.today - 2.days)
    create(:media_content, membership: nil, created_at: Date.today - 2.days)
    create(:media_content, membership: nil, created_at: Date.today)
    create(:media_content, membership_id: nil, membership_type: 'MediaContainer', created_at: Date.today - 2.days)

    task = RemoveMediaContentWithoutMembership.new
    expect{ task.call }.to change(MediaContent, :count).by(-2)
  end
end
