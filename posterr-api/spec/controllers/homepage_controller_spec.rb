require 'rails_helper'
describe "Homepage controller", type: :request do
  let(:user) { User.last }
  let(:last_teen_posts) { Post.order(created_at: :desc).limit(10) }
  let(:first_teen_posts) { Post.order(created_at: :asc).limit(10) }
  let(:yesterday_beginning_of_day) { Date.yesterday.beginning_of_day.strftime('%Y-%m-%d %T') }
  let(:yesterday_end_of_day) { Date.yesterday.end_of_day.strftime('%Y-%m-%d %T') }
  let(:yesterday_middle_of_day) { Date.yesterday.middle_of_day.strftime('%Y-%m-%d %T') }

  before(:all) do
    Post.delete_all
    user = FactoryBot.create(:user, name: Faker::Name.first_name)
    FactoryBot.create_list(:post, 10,
                           { user_id: user.id, content: 'content', created_at: Date.yesterday.beginning_of_day })
    FactoryBot.create_list(:post, 10,
                           { user_id: user.id, content: 'content', created_at: Date.yesterday.end_of_day })

  end
  it 'should returns last teen posts' do
    get '/homepage'
    expect(response).to have_http_status :ok
    expect(JSON.parse(response.body).size).to eq(10)
    expect(JSON.parse(response.body)).to eq(JSON.parse(last_teen_posts.to_json))
  end
  it 'should return first teen posts' do
    get '/homepage?offset=1'
    expect(response).to have_http_status :ok
    expect(JSON.parse(response.body).size).to eq(10)
    expect(JSON.parse(response.body)).to eq(JSON.parse(first_teen_posts.to_json))
  end
  it 'should return yesterday beginning of day posts' do
    get "/homepage?end_date=#{yesterday_beginning_of_day}"
    expect(response).to have_http_status :ok
    expect(JSON.parse(response.body).size).to eq(10)
    expect(JSON.parse(response.body)).to eq(JSON.parse(Post.where('created_at <= ?',
                                                                  Date.yesterday.middle_of_day).to_json))
  end
  it 'should return yesterday end of day posts' do
    get "/homepage?start_date=#{yesterday_middle_of_day}"
    expect(response).to have_http_status :ok
    expect(JSON.parse(response.body).size).to eq(10)
    expect(JSON.parse(response.body)).to eq(JSON.parse(Post.where('created_at >= ?', Date.yesterday.middle_of_day).to_json))
  end
end
