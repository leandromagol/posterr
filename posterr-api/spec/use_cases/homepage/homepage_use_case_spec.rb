require 'rails_helper'
RSpec.describe Homepage::HomePageUseCase do
  let(:user) { User.last }
  let(:last_week_posts) { Post.where('created_at <= ?', Date.yesterday) }
  let(:yesterday_posts) { Post.where('created_at >= ?', Date.yesterday) }
  let(:all_posts) { Post.all }
  let(:last_teen_posts) { Post.order(created_at: :desc).limit(10) }
  before(:all) do
    Post.delete_all
    user = FactoryBot.create(:user, name: Faker::Name.first_name)
    FactoryBot.create_list(:post, 10,
                           { user_id: user.id, content: 'content', created_at: Date.yesterday.last_week.beginning_of_day })
    FactoryBot.create_list(:post, 10,
                           { user_id: user.id, content: 'content', created_at: Date.yesterday.beginning_of_day })
  end
  context 'When no receive any parameters' do
    subject { described_class.new.execute }
    let(:expected) { subject }

    it 'should return last teen posts' do
      expect(expected.length).to eq(last_teen_posts.length)
      expect(expected.to_a).to eq(last_teen_posts.limit(10).to_a)
    end
  end
  context 'when user is set and all_posts is false' do
    subject { described_class.new.execute(user: nil, all_posts: false) }
    it 'should return a error' do
      expect { subject }.to raise_error(InvalidUserError)
    end
  end
  context 'when receive user and all_posts is false' do
    subject { described_class.new.execute(user: user, all_posts: false) }
    let(:expected) { subject }
    it 'should return user last teen posts' do
      expect(expected.to_a).to eq(user.posts.order(created_at: :desc).limit(10).to_a)
    end
  end
  context 'when receive user and all_posts is false and offset is 2' do
    subject { described_class.new.execute(user: user, all_posts: false, offset: 2) }
    let(:expected) { subject }
    it 'should return user next last teen posts' do
      expect(expected.to_a).to eq(user.posts.order(created_at: :desc).offset(2 * 10).limit(10).to_a)
    end
  end
end
