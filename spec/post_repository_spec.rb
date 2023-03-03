require 'post_repository'

def reset_posts_table
  seed_sql = File.read('spec/seeds_posts.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

RSpec.describe PostRepository do
  
  before(:each) do 
    reset_posts_table
  end

  it "returns all posts" do
    repo = PostRepository.new

    posts = repo.all

    posts.length # => 3

    expect(posts[0].title).to eq 'first post'
    expect(posts[0].content).to eq 'intro'
    expect(posts[0].views).to eq 1
    expect(posts[0].user_id).to eq 1

    expect(posts[1].title).to eq 'second post'
    expect(posts[1].content).to eq 'middle'
    expect(posts[1].views).to eq 10
    expect(posts[1].user_id).to eq 1

    expect(posts[2].title).to eq 'third post'
    expect(posts[2].content).to eq 'end'
    expect(posts[2].views).to eq 20
    expect(posts[2].user_id).to eq 1
  end

  it "returns a single post when given an id value" do
    repo = PostRepository.new

    post = repo.find(1)

    expect(post.id).to eq 1
    expect(post.title).to eq 'first post'
    expect(post.content).to eq 'intro'
    expect(post.views).to eq 1
    expect(post.user_id).to eq 1
  end

  it "creates a new post" do
    repo = PostRepository.new

    post = Post.new
    post.title = 'fourth post'
    post.content = 'back again'
    post.views = 50
    post.user_id = 1

    repo.create(post)

    all_posts = repo.all

    expect(all_posts).to include(
      have_attributes(
        title: post.title,
        content: post.content,
        views: post.views
      )
    )
  end

  it "deletes a post when given an id value" do
    repo = PostRepository.new

    repo.delete(1)

    posts = repo.all

    expect(posts.length).to eq 2
    expect(posts.last.title).to eq 'third post'
  end

  it "updates a record when given an updated post object" do
    repo = PostRepository.new

    post = repo.find(1)
    post.title = 'nolongerfirstpost'

    repo.update(post)

    updated_post = repo.find(1)
    expect(updated_post.title).to eq 'nolongerfirstpost'
    expect(updated_post.content).to eq 'intro'
  end
  
end