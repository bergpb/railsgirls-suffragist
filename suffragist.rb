require 'sinatra'
require 'yaml/store'
require 'byebug'
require 'sinatra/reloader'

Choices = {
  'HAM' => 'Hamburger',
  'PIZ' => 'Pizza',
  'CUR' => 'Curry',
  'NOO' => 'Noodles',
}

Votes = { '/vote_food' => 'Food' }

get '/' do
  @title = 'Welcome to the Suffragist!'
  erb :index
end

get '/vote_food' do
  @title = 'Welcome to the Suffragist!'
  erb :vote
end

post '/cast' do
  @title = 'Thanks for casting your vote!'
  @vote  = params['vote']
  @store = YAML::Store.new 'votes.yml'
  @store.transaction do
    @store['votes'] ||= {}
    @store['votes'][@vote] ||= 0
    @store['votes'][@vote] += 1
  end
  erb :cast
end

get '/results' do
  @title = 'Results so far:'
  @store = YAML::Store.new 'votes.yml'
  @votes = @store.transaction { @store['votes'] }
  erb :results
end
