require 'rails_helper'
RSpec.describe Profile::GetUserProfileUseCase do
  let(:user) { FactoryBot.create(:user, name: Faker::Name.first_name) }
  context 'when executes get profile use case' do
    subject { described_class.new.execute(user: user) }
    let(:expected) { subject }

    it 'should return a user profile' do
      expect(expected.to_s).to eq({ json: { username: user.name, user_posts_count: user.posts.length,
                                  date_joined: user.date_joined } }.to_s)
    end
  end
end
