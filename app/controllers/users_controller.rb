class UsersController < ApplicationController
  
  before_action :is_logged_in, except: %i[create new]
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_alt, except: %i[]
  before_action :is_same_acc, only: %i[edit update delete]

  # GET /users or /users.json
  def index
    @users = User.all
  end

  # GET /users/1 or /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users or /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "User was successfully created." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1 or /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: "User was successfully updated." }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1 or /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: "User was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  #custom define ---------------------------------------------------------------------------------------
  def main
    if is_same_acc
      @user.clearBucket
      @fav_items = @user.getAllItemFromFavorites
      puts "-------------------fav item #{@fav_items}"
      render "/user_pages/main"
    end
  end

  def addItemToBucket
    #puts "----------#{params[:added_item_id]}"
    #checkItemIdValid
    tmp = params[:added_item_id].to_i
    res = @user.bucket.addItemToBucket(tmp)
    if res == false
      flash[:error] = "Invalid Item"
      returnToUserMain
    else
      flash[:success] = "Added Item to Your Bucket"
      #to store
      sid = Item.find(tmp).store.id
      redirect_to "/visitStore/#{sid}"
    end
  end

  def visitStore
    tmp = params[:store_id].to_i
    @user.bucket.checkBucketItemToStore(tmp)
    @store = Store.find_by(id: tmp)
    render "/user_pages/visitStore"
  end

  #end custom define ---------------------------------------------------------------------------------------

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:username, :password, :email, :name, :address, :phoneNo, :gender, :birthday)
    end

    #custom define --------------------------------------------
    def is_logged_in
      if (session[:user_id] != nil)
        @user = User.find(session[:user_id])
        return true;
      else 
        redirect_to :userlogin, notice: "Please Login"
      end
    end

    def is_same_acc
      if (@user.id == nil || session[:user_id] == nil || session[:user_id] != @user.id)
        flash[:error] = "Unauthorized action!!"
        redirect_to :usermain
        #return false;
      else 
        return true
      end
    end

    def set_alt
      session[:alt] = "user"
    end

    def returnToUserMain
      redirect_to :usermain
    end
    #end custom define --------------------------------------------
end
