require 'rails_helper'
RSpec.describe Profile::FeedUseCase do
  describe '#execute' do
    let(:user) { User.last }
    before(:all) do
      user = FactoryBot.create(:user, name: Faker::Name.first_name)
      FactoryBot.create_list(:post, 10,
                             { user_id: user.id, content: 'content', created_at: Date.yesterday.last_week })
    end
    context 'when executes feed use case' do
      subject { described_class.new.execute(user: user) }
      it 'should return first five posts' do
        is_expected.to eq(user.posts.order(created_at: :desc).limit(5))
      end
    end
    context 'when executes feed use case' do
      subject { described_class.new.execute(user: user, offset: 2) }
      it 'should return next five posts' do
        is_expected.to eq(user.posts.order(created_at: :desc).offset(2 * 5).limit(5))
      end
    end
  end
end
