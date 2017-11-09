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

  delete '/tweets/:id/delete' do
    if session[:user_id] != nil
      tweet = Tweet.find_by(id: params[:id])
      user = User.find_by(id: session[:user_id])
      if user.id == tweet.user.id
        tweet.destroy
        "Tweet was deleted"
      else
        "Can't delete someone else's tweet"
      end
    else
      redirect to '/login'
    end
  end

  get '/tweets/:id/edit' do
    if session[:user_id] != nil
      @tweet = Tweet.find_by(id: params[:id])
      @user = User.find_by(id: session[:user_id])
      @session = session
      if @user.id == @tweet.user.id
        erb :'tweets/edit_tweet'
      else
        "Can't edit someone else's tweet"
      end
    else
      redirect to '/login'
    end
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
      user = User.find_by(username: params[:username])
      if user && user.authenticate(params[:password])
        session[:user_id] = user.id
        redirect to '/tweets'
      else
        redirect to '/login'
      end
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

  patch '/tweets/:id' do
    tweet = Tweet.find_by(id: params[:id])
    if params[:content] != ""
      tweet.update(content: params[:content])
      redirect to "/tweets/#{tweet.id}"
    else
      redirect to "/tweets/#{tweet.id}/edit"
    end
  end

end
