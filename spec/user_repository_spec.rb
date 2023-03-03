require 'user_repository'

def reset_users_table
  seed_sql = File.read('spec/seeds_users.sql')
  connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
  connection.exec(seed_sql)
end

RSpec.describe UserRepository do

  before(:each) do 
    reset_users_table
  end
  
  it "returns all users" do
    repo = UserRepository.new

    users = repo.all

    expect(users.length).to eq 3

    expect(users[0].username).to eq 'firstuser'
    expect(users[0].email_address).to eq 'firstuser@mail.com' 

    expect(users[1].username).to eq 'seconduser'
    expect(users[1].email_address).to eq 'seconduser@mail.com' 

    expect(users[2].username).to eq 'thirduser'
    expect(users[2].email_address).to eq 'thirduser@mail.com' 
  end

  it "finds a single user when given an id value" do
    repo = UserRepository.new

    user = repo.find(1)

    expect(user.id).to eq 1
    expect(user.username).to eq 'firstuser'
    expect(user.email_address).to eq 'firstuser@mail.com' 
  end

  it "finds a single user when given an id value" do
    repo = UserRepository.new

    user = repo.find(2)

    expect(user.id).to eq 2
    expect(user.username).to eq 'seconduser'
    expect(user.email_address).to eq 'seconduser@mail.com' 
  end

  it "creates a new user" do
    repo = UserRepository.new

    user = User.new
    user.username = 'fourthuser'
    user.email_address = 'fourthuser@mail.com'

    repo.create(user)

    users = repo.all

    last_added = users.last

    expect(last_added.username).to eq 'fourthuser'
    expect(last_added.email_address).to eq 'fourthuser@mail.com'
  end

  it "deletes a user when given an id value" do
    repo = UserRepository.new

    repo.delete(3)

    users = repo.all

    expect(users.length).to eq 2
    expect(users.last.username).to eq 'seconduser'
    expect(users.last.email_address).to eq 'seconduser@mail.com'
  end

  it "updates a record when given a user object" do
    repo = UserRepository.new

    user = repo.find(1)

    user.username = 'nolongerfirst'

    repo.update(user)

    updated_user = repo.find(1)

    expect(updated_user.username).to eq 'nolongerfirst'
    expect(updated_user.email_address).to eq 'firstuser@mail.com'
  end

end