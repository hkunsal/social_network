require "post_repository"
require 'pg'

RSpec.describe PostRepository do
  def reset_social_network
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_social_network
  end

  it "returns the list of posts" do
    repo = PostRepository.new

    posts = repo.all
    expect(posts.length).to eq(3)
    expect(posts.first.id).to eq('1') 
    expect(posts.first.title).to eq('Hello World!')
    expect(posts.first.content).to eq('This is my first post.')
    expect(posts.first.number_of_views).to eq('50')

    expect(posts[1].id).to eq('2')
    expect(posts[1].title).to eq('My Second Post')
    expect(posts[1].content).to eq('This is my second post.')
    expect(posts[1].number_of_views).to eq('100')
  
  end

  it "returns first post as single post" do
    repo = PostRepository.new

    post = repo.find(1) 
    expect(post.title).to eq('Hello World!')
    expect(post.content).to eq('This is my first post.')
    expect(post.number_of_views).to eq('50')
    expect(post.user_id).to eq('1')
  end

  it "returns the second post as single user" do
    repo = PostRepository.new

    post = repo.find(2) 
    expect(post.title).to eq('My Second Post')
    expect(post.content).to eq('This is my second post.')
    expect(post.number_of_views).to eq('100')
  end

  it "creates a new post" do
    repo = PostRepository.new

    new_post = Post.new
    new_post.title = 'New post in my blog!'
    new_post.content = 'Long time no see my friends.'
    new_post.number_of_views = '250'

    repo.create(new_post) # => nil

    posts = repo.all
    last_post = posts.last
    expect(last_post.title).to eq('New post in my blog!')
    expect(last_post.content).to eq('Long time no see my friends.')
    expect(last_post.number_of_views).to eq('250')
  end

  it "deletes the post with id 1" do
    repo = PostRepository.new
    id_to_delete = 1

    repo.delete(id_to_delete)

    all_posts = repo.all

    expect(all_posts.length).to eq(2)
    expect(all_posts.first.id).to eq('2')
  end
  
  it "deletes two posts" do
    repo = PostRepository.new
    repo.delete(1)
    repo.delete(2)

    all_posts = repo.all

    expect(all_posts.length).to eq(1)
  end

  it "updates the post with new values" do
    repo = PostRepository.new

    post = repo.find(1)
    post.title = 'A new title'
    post.content = 'Something new has happened'
    post.number_of_views = 350

    repo.update(post)

    updated_post = repo.find(1)
    expect(updated_post.title).to eq('A new title')
    expect(updated_post.content).to eq('Something new has happened')
    expect(updated_post.number_of_views).to eq('350')
  end

  it "updates the post with only a new title" do
    repo = PostRepository.new

    post = repo.find(1)
    post.title = 'Newest Title'

    repo.update(post)

    updated_post= repo.find(1)
    expect(updated_post.title).to eq('Newest Title')
    expect(updated_post.content).to eq('This is my first post.')
  end
end