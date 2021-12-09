require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    @store1 = stores(:one)
    @store2 = stores(:two)
  end

  # test "register_login_success" do
  #   visit "/users/new"
  #   fill_in "Username", with: "testLogin1"
  #   fill_in "Email", with: "testLogin1"
  #   fill_in "Name", with: "testLogin1"
  #   fill_in "Address", with: "testLogin1Addr"
  #   fill_in "Password", with: "12345"
  #   fill_in "Gender", with: "Male"
  #   fill_in "Phoneno", with: "0800000000"
  #   click_on "Create User"
  #   assert_text "User was successfully created."

  #   visit "/userlogin"
  #   fill_in "Email", with: "testLogin1"
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
  # end

  # test "user_login" do
  #   visit :userlogin
  #   visit "/userlogin"
  #   fill_in "Email", with: @user1.email
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
  #   visit :userlogin
  #   visit "/userlogin"
  #   fill_in "Email", with: @user2.email
  #   fill_in "Password", with: "12345"
  #   click_on "Login"
  #   assert_text "Login Successfully"
  # end

  test "buy_item" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    visit "/visitStore/#{@store1.id}"
    assert_text "Welcome to \"#{@store1.storeName}\""

    visit "add_item_to_bucket/#{@store1.items.first.id}"
    assert_text "Added Item to Your Bucket"
    visit "add_item_to_bucket/#{@store1.items.second.id}"
    assert_text "Added Item to Your Bucket"

    click_on "Purchase"
    assert_text "Confirm Payment"

    click_on "Confirm"
    assert_text "Thank you for Shopping,"
    
    fill_in "Rating Score (0-5)", with: 3
    fill_in "Comment", with: "testComment testComment testComment"
    click_on "Create Rating"

    #let selenium acpert alert
    page.driver.browser.switch_to.alert.accept #auto click "ok"

    assert_text "Thank you for your rating!!"    
    #rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
  end

  






  # test "updating a User" do
  #   visit users_url
  #   click_on "Edit", match: :first

  #   fill_in "Address", with: @user.address
  #   fill_in "Birthday", with: @user.birthday
  #   fill_in "Email", with: @user.email
  #   fill_in "Gender", with: @user.gender
  #   fill_in "Name", with: @user.name
  #   fill_in "Password digest", with: @user.password_digest
  #   fill_in "Phoneno", with: @user.phoneNo
  #   fill_in "Username", with: @user.username
  #   click_on "Update User"

  #   assert_text "User was successfully updated"
  #   click_on "Back"
  # end

  # test "destroying a User" do
  #   visit users_url
  #   page.accept_confirm do
  #     click_on "Destroy", match: :first
  #   end

  #   assert_text "User was successfully destroyed"
  # end

end
