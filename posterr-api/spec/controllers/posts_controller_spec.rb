require 'rails_helper'
RSpec.describe "Posts controller", type: :request do
  let(:user) {  FactoryBot.create(:user, name: Faker::Name.first_name) }
  let(:user2) { FactoryBot.create(:user, name: Faker::Name.first_name) }
  let(:post1) { Post.create(user_id: user.id, content: 'content') }
  before(:each) do
    Post.delete_all
  end
  context 'POST /posts' do
    it 'should create a post' do
      expect {
        post '/posts', params: { user_id: user.id, content: Faker::String.random(length: 15).gsub(/\W/, '') }
      }.to change { Post.count }.from(0).to(1)
      expect(response).to have_http_status :created
    end
  end
  describe 'POST /posts/repost' do
    let!(:user) {  FactoryBot.create(:user, name: Faker::Name.first_name) }
    let!(:user2) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let!(:post1) { Post.create(user_id: user.id, content: 'content') }
    it 'should create a repost' do
      expect {
        post '/posts/repost', params: { user_id: user2.id, post_id: Post.first.id }
      }.to change { Post.count }.from(1).to(2)
      expect(response).to have_http_status :created
    end
  end
  context 'POST /posts/quote_post' do
    let!(:user) {  FactoryBot.create(:user, name: Faker::Name.first_name) }
    let!(:user2) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let!(:post1) { Post.create(user_id: user.id, content: 'content') }
    let!(:post2) { Post.create(user_id: user2.id, post_id: Post.first.id) }
    it 'should create a quote_post' do
      expect {
        post '/posts/quote_post',
             params: { user_id: user.id, post_id: Post.second.id,
                       content: Faker::String.random(length: 15).gsub(/\W/, '') }
      }.to change { Post.count }.from(2).to(3)
      expect(response).to have_http_status :created
    end
  end
end
