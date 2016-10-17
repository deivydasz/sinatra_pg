require 'sinatra'
require './customer'
require './customer_generator'
require './main'
require 'pg'
require 'pry'
require 'pry-nav'

$pg = PGconn.connect("localhost", 5432, '', '', "vardai_02", "postgres", "123456")

class MyApp < Sinatra::Base

	get '/' do
		@per_page = 10
		@page = params['page'].to_i
		@customers = Customer.all(@per_page, @page)
		@last_page = Customer.count / @per_page
  	

		#binding.pry
		erb :main
	end 

	get '/customers/:id' do
    @customer = Customer.find(params[:id])
    erb :show_customer
  end

  get '/customers/:id/edit' do
    @customer = Customer.find(params[:id])
    erb :edit_customer
  end

  post '/customers' do
	  @customer = Customer.find(params[:id])
  	@customer.update(params)
 		redirect "customers/#{params[:id]}"
  end  

  get '/new_customer' do
  	@customer = Customer.new(name: '', lastname: '', age: nil, code: nil, id: nil)
		erb :new_customer
  end

  post '/new_customer' do 
  	@customer = Customer.new(name: params[:name], lastname: params[:lastname], age: 
  														params[:age], code: params[:code], id: nil)
  	@customer.create
  	erb :show_customer
  end

	def pg	
	  $pg
	end

end
	
	MyApp.run!
