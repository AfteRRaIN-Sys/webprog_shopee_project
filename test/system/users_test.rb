require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @user1 = users(:one)
    @user2 = users(:two)
    @store1 = stores(:one)
    @store2 = stores(:two)
    @bucket1 = buckets(:one)
    @bucket2 = buckets(:two)
    @fav1 = favorites(:one)
    @fav2 = favorites(:two)
    @ib1 = item_on_buckets(:one)
    @ib2 = item_on_buckets(:two)
    @item1 = items(:one)
    @item2 = items(:two)
    @item3 = items(:three)
    @item4 = items(:four)
    @ol1 = order_line_items(:one)
    @ol2 = order_line_items(:two)
    @ol3 = order_line_items(:three)
    @ol4 = order_line_items(:four)
    @o1 = orders(:one)
    @o2 = orders(:two)
    @r1 = ratings(:one)
    @r2 = ratings(:two)
    @t1 = tags(:one)
    @t2 = tags(:two)
  end

  test "register_login_success" do
    visit "/users/new"
    fill_in "Username", with: "testLogin1"
    fill_in "Email", with: "testLogin1"
    fill_in "Name", with: "testLogin1"
    fill_in "Address", with: "testLogin1Addr"
    fill_in "Password", with: "12345"
    fill_in "Gender", with: "Male"
    fill_in "Phoneno", with: "0800000000"
    click_on "Create User"
    assert_text "User was successfully created."

    visit "/userlogin"
    fill_in "Email", with: "testLogin1"
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
  end

  test "user_login" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user2.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
  end

  test "buy_item_success" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    visit "/visitStore/#{@store1.id}"
    assert_text "Welcome to \"#{@store1.storeName}\""

    added_item1 = @store1.items.first.id
    added_item2 = @store1.items.last.id
    quantity1 = 2
    quantity2 = 5
    for i in quantity1.times
      visit "/add_item_to_bucket/#{added_item1}"
      assert_text "Added Item to Your Bucket"
    end
    for i in quantity2.times
      visit "/add_item_to_bucket/#{added_item2}"
      assert_text "Added Item to Your Bucket"
    end

    click_on "Purchase"
    assert_text "Confirm Payment"

    click_on "Confirm"
    assert_text "Thank you for Shopping,"

    assert_difference 'Rating.count', 1, 'A new rating should be created' do
      fill_in "Rating Score (0-5)", with: 3
      fill_in "Comment", with: "testComment testComment testComment"
      click_on "Create Rating"
      #let selenium acpert alert
      page.driver.browser.switch_to.alert.accept #auto click "ok"

      assert_text "Thank you for your rating!!"
      #rescue Selenium::WebDriver::Error::UnexpectedAlertOpenError
    end
    o = @user1.orders.last
    visit "/showSpecificOrder/#{o.id}"

    assert_text "Order ##{o.id} From #{o.order_line_items.first.item.store.storeName}"
    assert_text "Quantity : #{quantity1}"
    assert_text "Quantity : #{quantity2}"
    assert_text "#{Item.find_by(id: added_item2).name}"
    assert_text "#{Item.find_by(id: added_item2).name}"
  end

  test "add_two_item_different_store_in_bucket" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    added_item1 = @store1.items.first.id
    added_item2 = @store2.items.last.id

    for i in 0..2
      visit "/add_item_to_bucket/#{added_item1}"
      assert_text "Added Item to Your Bucket"

      visit "/add_item_to_bucket/#{added_item2}"
      assert_text "Added Item to Your Bucket"
    end

    assert_text "Welcome to \"#{Item.find_by(id: added_item2).store.storeName}\""
    
  end

  test "buy_empty_bucket" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    visit "/visitStore/#{@store1.id}"
    assert_text "Welcome to \"#{@store1.storeName}\""

    # visit "add_item_to_bucket/#{@store1.items.first.id}"
    # assert_text "Added Item to Your Bucket"
    # visit "add_item_to_bucket/#{@store1.items.second.id}"
    # assert_text "Added Item to Your Bucket"

    click_on "Purchase"
    assert_text "Please add some items before purchase!!"

  end

  test "confirm_purchase_empty_bucket" do
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    visit "/confirmed_purchased"
    assert_text "Please go through purchase page in store!!"

  end
    
  test "confirm_purchase_bypass_purchase" do

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

    visit "/confirmed_purchased"
    assert_text "Please go through purchase page in store!!"

  end

  test "updating a User" do
    # visit users_url
    # click_on "Edit", match: :first
    visit :userlogin
    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    visit "/users/#{@user1.id}/edit"

    fill_in "Address", with: "xxx"
    fill_in "Email", with: @user1.email
    fill_in "Gender", with: @user1.gender
    fill_in "Name", with: @user1.name
    fill_in "Password", with: "123456"
    fill_in "Phoneno", with: @user1.phoneNo
    fill_in "Username", with: @user1.username
    click_on "Update User"

    assert_text "User was successfully updated"
  end

end
