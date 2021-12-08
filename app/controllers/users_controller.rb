class UsersController < ApplicationController
  
  before_action :is_logged_in, except: %i[create new]
  before_action :set_user, only: %i[ show edit update destroy ]
  before_action :set_alt, except: %i[]
  before_action :is_same_acc, only: %i[show edit update delete]
  before_action :checkIsAdmin, only: %i[index]
  before_action :cancelPurchaseSession, except: %i[confirmPurchase]

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
      if @user.save && @user.createNewBucket
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

  def addStoreToFavorite
    store_id = params[:store_id].to_i
    res = @user.addToFavorite(store_id)
    if res = false
      flash[:error] = "You already added this store to favorite"
    end
    redirect_to "/visitStore/#{store_id}"
  end

  def deleteStoreFromFavorite
    store_id = params[:store_id].to_i
    res = @user.removeFromFavorite(store_id)
    if res == false
      flash[:error] = "This store is not yet on your favorite"
    end
    redirect_to "/visitStore/#{store_id}"
  end

  def purchase
    b = @user.bucket
    @total = b.getTotalPayment
    puts "-------------#{@total}"
    setPurchaseSession
    render "/user_pages/purchasePage"
  end

  def confirmPurchase
    if session[:purchase] == 1
      b = @user.bucket
      @total = b.getTotalPayment
      puts "-------------#{@total}"
      o = Order.new
      res = o.moveBucketToOrder(@user.id, b.id)
      if res
        @user.clearBucket
        flash[:success] = "Thank you for Shopping, You spend #{@total} Baht. Your Order will be arrived soon!!"
      else
        flash[:error] = "Purchase Unsuccessfull, Please try again!"
      end
      cancelPurchaseSession
    else
      flash[:error] = "Please go through purchase page in store!!"
    end
    returnToUserMain
  end

  def showOrders
    @table = @user.getAllPrevOrder
    @prevOrder = @table.pluck("store_id", "order_id").sort
    #returnToUserMain
    render "/user_pages/showOrders"
  end

  def showSpecificOrder
    @order = @user.getOrder(params[:order_id].to_i)
    if @order != nil
      @ols = @order.order_line_items
        if @ols != nil
          @store = @ols[0].item.store
          render "/user_pages/showSpecificOrder"
          return
        end
    end
    flash[:error] = "Order doesn't exist or Invalid Order"
    redirect_to :showOrders
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

    def setPurchaseSession
      session[:purchase] = 1
    end

    def cancelPurchaseSession
      session[:purchase] = 0
    end    

    def returnToUserMain
      redirect_to :usermain
    end

    #addon-admin
    def checkIsAdmin
      puts "------check admin"
      if session[:user_id] == 1
        return true
      end
      flash[:error] = "Unauthorized Action!!"
      returnToUserMain
      return false
    end
    #end custom define --------------------------------------------
end
