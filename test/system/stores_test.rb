require "application_system_test_case"

class StoresTest < ApplicationSystemTestCase
  setup do
    @store1 = stores(:one)
    @store2 = stores(:two)
  end

  # test "register_login_success" do
  #   visit "/stores/new"
  #   fill_in "Storename", with: "testLogin1"
  #   fill_in "Password", with: "12345"
  #   fill_in "Address", with: "testLogin1Addr"
  #   click_on "Create Store"
  #   assert_text "Store was successfully created."

  #   visit "/storelogin"
  #   fill_in "Storename", with: "testLogin1"
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
  # end

  # test "store_login" do
    
  #   visit :storelogin
  #   fill_in "Storename", with: @store1.storeName
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
    
  #   visit :storelogin
  #   fill_in "Storename", with: @store1.storeName
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
  # end
  
end
