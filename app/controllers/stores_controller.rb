class StoresController < ApplicationController
  before_action :is_logged_in, except: %i[new create]
  before_action :set_alt, except: %i[]

  before_action :set_store, only: %i[ show edit update destroy ]
  before_action :is_same_acc, only: %i[ edit update destroy ]

  # GET /stores or /stores.json
  def index
    @stores = Store.all
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)
    if @store.save
      flash[:notice] = "Store was successfully created."
    else
      flash[:error] = "Found an error while creating account."
    end
    redirect_to :storelogin
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    if is_same_acc
      @store.destroy
      respond_to do |format|
        format.html { redirect_to :storelogin, notice: "Store was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  #custom define --------------------------------------------
  
  def main
    render "store_pages/main"
  end

  def addItem
    @item = Item.new
    render "store_pages/addItem"
  end

  def checkAddItem
    #login_user = params[:user] #simple form pass "user = {email:"", password:""} to this func"
    #{"name"=>"Item2", "price"=>"99", "description"=>"Test Item"}
    #Item.create(store_id: 2, name: "test3", price: 20.0, description: "testing")
    #"item"=>{"name"=>"testItem", "price"=>"99", "description"=>"just mock", "tag_ids"=>"comic fun haha"}

    new_item_detail = params[:item]
    puts "----------item detail #{new_item_detail}"

    #only keep name in lowercase
    tmp = Item.find_by(store_id: getCurrentSID,name: new_item_detail[:name].downcase)

    if tmp != nil
      flash[:error] = "Your store are already selling this product!"
    else
      @item = Item.new(store_id: getCurrentSID(), name: new_item_detail[:name].downcase, price: new_item_detail[:price], description: new_item_detail[:description])
      if @item.save
        res = @item.addItemTag(params[:item][:tag_ids])
        if res 
          flash[:success] = "Add Item #{new_item_detail[:name]} successfully!!"
        end
      else
        flash[:error] = "Save Item Unsuccess"
      end
    end
    
    returnToStoreMain

  end

  #end custom define --------------------------------------------

  private
    # Use callbacks to share common setup or constraints between actions.

    def checkRedundantName(a,b)
      if (a.downcase == b.downcase) 
        return true
      end
      return false
    end

    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      params.require(:store).permit(:storeName, :password, :address)
    end

    #custom define --------------------------------------------

    def getCurrentSID
      return session[:store_id]
    end

    def returnToStoreMain
      redirect_to :storemain
    end

    def is_logged_in
      if (session[:store_id] != nil)
        @store = Store.find(session[:store_id])
        return true;
      else 
        redirect_to :storelogin, notice: "Please Login"
      end
    end

    def is_same_acc
      puts "-------------------------#{@store.id}"
      if (@store.id == nil || session[:store_id] == nil || session[:store_id] != @store.id)
        flash[:error] = "Unauthorized action!"
        redirect_to :storemain
        #return false;
      else 
        return true
      end
    end

    def set_alt
      session[:alt] = "store"
    end

    #end custom define --------------------------------------------
end
