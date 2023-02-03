require "user_repository"
require 'pg'

RSpec.describe UserRepository do

  def reset_social_network
    seed_sql = File.read('spec/seeds_social_network.sql')
    connection = PG.connect({ host: '127.0.0.1', dbname: 'social_network_test' })
    connection.exec(seed_sql)
  end

  before(:each) do
    reset_social_network
  end

  it "returns the list of users" do
    repo = UserRepository.new

    users = repo.all
    expect(users.length).to eq(3)
    expect(users.first.id).to eq('1') 
    expect(users.first.email).to eq('user1@example.com')
    expect(users.first.username).to eq('user1')

    expect(users[1].id).to eq('2')
    expect(users[1].email).to eq('hkunsal@gmail.com')
    expect(users[1].username).to eq('handekucukunsal')
  
  end

  it "returns user1 as single user" do
    repo = UserRepository.new

    user = repo.find(1) 
    expect(user.email).to eq('user1@example.com')
    expect(user.username).to eq('user1')
  end

  it "returns alismith as single user" do
    repo = UserRepository.new

    user = repo.find(3) 
    expect(user.email).to eq('alismith@gmail.com')
    expect(user.username).to eq('alismith')
  end

  it "creates a new user" do
    repo = UserRepository.new

    new_user = User.new
    new_user.email = 'johnappleseed@icloud.com'
    new_user.username = 'jappleseed'

    repo.create(new_user) # => nil

    users = repo.all
    last_user = users.last
    expect(last_user.email).to eq('johnappleseed@icloud.com')
    expect(last_user.username).to eq('jappleseed')
  end

  it "deletes the user with id 1" do
    repo = UserRepository.new
    id_to_delete = 1

    repo.delete(id_to_delete)

    all_users = repo.all

    expect(all_users.length).to eq(2)
    expect(all_users.first.id).to eq('2')
  end
  
  it "deletes the two users" do
    repo = UserRepository.new
    repo.delete(1)
    repo.delete(2)

    all_users = repo.all

    expect(all_users.length).to eq(1)
  end

  it "updates the user with new values" do
    repo = UserRepository.new

    user = repo.find(1)
    user.email = 'something@anything.com'
    user.username = 'something'

    repo.update(user)

    updated_user = repo.find(1)
    expect(updated_user.email).to eq('something@anything.com')
    expect(updated_user.username).to eq('something')
  end

  it "updates the user with only a new email" do
    repo = UserRepository.new

    user = repo.find(1)
    user.email = 'new@email.com'

    repo.update(user)

    updated_user= repo.find(1)
    expect(updated_user.email).to eq('new@email.com')
    expect(updated_user.username).to eq('user1')
  end
end