require 'rails_helper'
RSpec.describe Homepage::DateFilterUseCase do
  describe '#execute' do
    let(:user) { User.last }
    let(:last_week_posts) { Post.where('created_at <= ?', Date.yesterday) }
    let(:yesterday_posts) { Post.where('created_at >= ?', Date.yesterday) }
    let(:all_posts) { Post.all }
    before(:all) do
      user = FactoryBot.create(:user, name: Faker::Name.first_name)
      FactoryBot.create_list(:post, 10,
                             { user_id: user.id, content: 'content', created_at: Date.yesterday.last_week.beginning_of_day })
      FactoryBot.create_list(:post, 10, { user_id: user.id, content: 'content', created_at: Date.yesterday.beginning_of_day })
    end
    context 'when start and end is nil' do
      subject { described_class.new.execute(start_date: nil, end_date: nil) }
      let(:expected) { subject }

      it 'should return all posts' do
        is_expected.to eql(expected)
        expect(expected.length).to eq(all_posts.length)
      end
    end
    context 'when start date is set' do
      subject { described_class.new.execute(start_date: Date.yesterday.beginning_of_day.to_s, end_date: nil) }
      let(:expected) { subject }

      it 'should return yesterday posts' do
        is_expected.to eql(expected)
        expect(expected.length).to eq(yesterday_posts.length)
      end
    end
    context 'when end date is set' do
      subject { described_class.new.execute(start_date: nil, end_date: Date.yesterday.to_s) }
      let(:expected) { subject }

      it 'should return last week posts posts' do
        is_expected.to eql(expected)
        expect(expected.length).to eq(last_week_posts.length)
      end
    end
  end
end
