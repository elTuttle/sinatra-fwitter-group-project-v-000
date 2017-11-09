require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    @session = session
    erb :index
  end

  get '/signup' do
    @session = session
    erb :'users/create_user'
  end

  get '/login' do
    @session = session
    erb :'users/login'
  end

  get '/tweets' do
    @user = User.find_by(id: session[:user_id])
    @session = session
    erb :'tweets/tweets'
  end

  get '/logout' do
    session.clear
    redirect '/login'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    @session = session
    #binding.pry
    erb :'users/show'
  end

  get '/tweets/new' do
    @session = session
    erb :'tweets/create_tweet'
  end

  get '/tweets/:id' do
    @tweet = Tweet.find_by(id: params[:id])
    @session = session
    erb :'tweets/show_tweet'
  end

  get '/tweets/:id/delete' do
    tweet = Tweet.find_by(id: params[:id])
    tweet.destroy
    "Tweet was deleted"
  end
  
  get '/tweets/:id/edit' do
    tweet = Tweet.find_by(id: params[:id])
    tweet.destroy
    "Tweet was deleted"
  end

  post '/signup' do
    if params[:username] == ""||params[:email] == ""||params[:password] == ""
      redirect to '/signup'
    else
      user = User.create(params)
      session[:user_id] = user.id
      redirect to '/tweets'
    end
  end

  post '/login' do
    if params[:username] == ""||params[:password] == ""
      redirect to '/login'
    else
      user = User.find_by(params)
      session[:user_id] = user.id
      redirect to '/tweets'
    end
  end

  post '/tweets' do
    if params[:content] != ""
      user = User.find_by(id: session[:user_id])
      tweet = Tweet.create(content: params[:content],user: user)
      redirect to "/users/#{user.slug}"
    else
      redirect to '/tweets/new'
    end
  end

end
