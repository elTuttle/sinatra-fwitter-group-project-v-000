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

end
