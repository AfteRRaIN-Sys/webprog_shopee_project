class ApplicationController < ActionController::Base

	#accessloginPage
	def userLoginPage
		clearCookie()
		session[:alt] = "user"
		render "layouts/userLoginPage.html.haml"
	end

	#login
	def userLogin
		#puts "-----> #{params[:login_type]}"
		#params[:login_type] = 

		login_user = params[:user] #simple form pass "user = {email:"", password:""} to this func"

	    #authenticate
	    exist_user = User.find_by(email: login_user[:email])
	    
	    if(exist_user != nil) 
	      exist_user = exist_user.authenticate(login_user[:password])
	    else
	      flash[:alert] = "Please Register!!"
	      redirect_to :userlogin
	      return
	    end 

	    if (exist_user != false)
	      flash[:success] = "Login Successfully"
	      session[:user_id] = exist_user.id
	      @user = exist_user
	      #puts "-----------------------------login as #{@user.name}"
	      #puts "-----------------------------login as #{session[:user_id]}"
	      redirect_to :usermain
	    else 
	      flash[:alert] = "Wrong Email or Password!!"
	      redirect_to :userlogin
	    end
	end


	def storeLoginPage
		clearCookie()
		session[:alt] = "store"
		render "layouts/storeLoginPage.html.haml"
	end

	def storeLogin
		puts "-------------------start login"
		login_store = params[:store] #simple form pass "user = {email:"", password:""} to this func"

	    #authenticate
	    exist_store = Store.find_by(storeName: login_store[:storeName])
	    
	    if(exist_store != nil) 
	      exist_store = exist_store.authenticate(login_store[:password])
	    else
	      flash[:alert] = "Please Register!!"
	      redirect_to :storelogin
	      return
	    end 

	    if (exist_store != false)
	      flash[:success] = "Login Successfully"
	      session[:store_id] = exist_store.id
	      @store = exist_store
	      puts "-----------------------------login as #{@store.storeName}"
	      puts "-----------------------------login as #{session[:store_id]}"
	      redirect_to :storemain
	    else 
	      flash[:alert] = "Wrong StoreName or Password!!"
	      redirect_to :storelogin
	    end
	end

	def clearCookie
		session[:store_id] = nil
		session[:user_id] = nil
	end

end
