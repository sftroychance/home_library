require "sinatra"
require "sinatra/reloader" if development?
require "tilt/erubis"
require "sinatra/content_for"
require "yaml"
require 'bcrypt'

configure do
  enable :sessions
  set :session_secret,
      '50d6deddaff3913a0b9631e04fd3d5fb039024dba75a7b4858cd9e032e45e243'
  set :erb, escape_html: true
end

helpers do

end

def project_root
  File.expand_path("..", __FILE__ )
end

def load_user_credentials
  YAML.load_file(project_root + '/users.yml')
end

def valid_credentials?(username, password)
  credentials = load_user_credentials

  credentials[username] &&
    BCrypt::Password.new(credentials[username]) == password
end

before do
  session[:books] ||= []
  session[:borrowers] ||= []
  session[:borrows] ||= []
end

get '/' do
  session[:user] = nil
  if session[:user]
    redirect '/dashboard'
  else
    redirect '/login'
  end
end

get '/dashboard' do
  # dashboard shows
  # - number of books in library
  # - number of books currently borrowed
  # - list of borrowed books (title, author, borrower, borrow date, days on loan, return book button?)

  @total_book_count = session[:books].size
  @borrowed_books = session[:borrows].select { |b| b[:return_date].nil? }
  # map to hash with title, author, borrower, borrow date, book_id and borrower_id
  # use ids to create links to book and borrower pages
  # or perhaps better to use reduce to save into an array of hashes
  # use select statements to get title, author, borrower
  # make this a method if this list will be pulled in multiple routes (likely)

  @borrowed_book_count = @borrowed_books.size

  erb :dashboard
end

get '/login' do
  puts session[:error]
  erb :login
end

post '/login' do
  if valid_credentials?(params[:login], params[:password])
    session[:success] = "Welcome!"
    redirect '/dashboard'
  else
    session[:error] = "Invalid login credentials!"
    status 422
    erb :login
  end
end