require 'rails_helper'

RSpec.describe Posts::PostUseCase do
  describe '#execute' do
    let(:user) { FactoryBot.create(:user, name: Faker::Name.first_name) }
    let(:last_post) { Post.order('created_at').last }
    let(:content) { Faker::String.random(length: 10) }
    let(:long_content) { Faker::String.random(length: 778) }
    context "when user don't exists" do
      subject { described_class.new.execute(user: nil, content: content) }
      it 'should return a error' do
        expect { subject }.to raise_error(InvalidUserError)
      end
    end
    context 'when user exists' do
      subject { described_class.new.execute(user: user, content: content) }
      it 'should return a post' do
        is_expected.to eq(last_post)
      end
    end
    context 'when user exists but post validation fails' do
      subject { described_class.new.execute(user: user, content: long_content) }
      let(:post) { Post.create(user_id: user.id, content: long_content) }
      it 'should return a to long content validation error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
