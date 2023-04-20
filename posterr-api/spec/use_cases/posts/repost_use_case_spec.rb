require 'rails_helper'

RSpec.describe Posts::RepostUseCase do
  describe '#execute' do
    let(:user) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let(:user2) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let(:content) { 'content' }
    let(:reposted_post) { FactoryBot.create(:post, user_id: user.id, content: 'content') }
    let(:last_post) { Post.order('created_at').last }
    let(:long_content) { Faker::String.random(length: 778) }
    context "when user don't exists" do
      subject { described_class.new.execute(user: nil, post: reposted_post) }
      it 'should return a error' do
        expect { subject }.to raise_error(InvalidUserError)
      end
    end
    context 'when user exists' do
      subject { described_class.new.execute(user: user2, post: reposted_post) }
      it 'should return a post' do
        is_expected.to eq({ json: { post: last_post } })
      end
    end
    context 'when user trying to repost a repost' do
      let(:repost) { Post.create(user_id: user2.id, post_id: reposted_post.id) }
      subject { described_class.new.execute(user: user, post: repost) }
      it 'should return a invalid repost error' do
        expect { subject }.to raise_error(StandardError, "you can't repost reposts")
      end
    end
    context 'when user trying repost your won post' do
      let(:repost) { Post.create(user_id: user2.id, content: 'content') }
      subject { described_class.new.execute(user: user2, post: repost) }
      it 'should return a invalid repost error' do
        expect { subject }.to raise_error(StandardError, "you can't repost reposts")
      end
    end
  end
end
