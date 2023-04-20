require 'rails_helper'
RSpec.describe Posts::QuotePostUseCase do
  describe '#execute' do
    let(:user) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let(:user2) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let(:content) { Faker::String.random(length: 10) }
    let(:quoted_post) { FactoryBot.create(:post, user_id: user.id, content: 'content') }
    let(:last_post) { Post.order('created_at').last }
    let(:long_content) { Faker::String.random(length: 778) }
    context "when user don't exists" do
      subject { described_class.new.execute(user: nil, post: quoted_post, content: content) }
      it 'should return a error' do
        expect { subject }.to raise_error(InvalidUserError)
      end
    end
    context 'when user exists' do
      subject { described_class.new.execute(user: user2, post: quoted_post, content: content) }
      it 'should return a post' do
        is_expected.to eq({ json: { post: last_post } })
      end
    end
    context 'when user trying quote a quote post' do
      let(:quote_post) { Post.create(user_id: user2.id, post_id: quoted_post.id, content: 'content') }
      subject { described_class.new.execute(user: user, post: quote_post, content: 'quote') }
      it 'should return a invalid repost error' do
        expect { subject }.to raise_error(StandardError, "you can't quote this posts")

      end
    end
    context 'when user trying repost your won post' do
      let(:repost) { Post.create(user_id: user2.id, content: 'content') }
      subject { described_class.new.execute(user: user2, post: repost, content: content) }
      it 'should return a invalid repost error' do
        expect { subject }.to raise_error(StandardError, "you can't quote this posts")
      end
    end
  end
end
