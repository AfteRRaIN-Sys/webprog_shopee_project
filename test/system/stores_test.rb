require "application_system_test_case"

class StoresTest < ApplicationSystemTestCase
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
    visit "/stores/new"
    fill_in "Storename", with: "testLogin1"
    fill_in "Password", with: "12345"
    fill_in "Address", with: "testLogin1Addr"
    click_on "Create Store"
    assert_text "Store was successfully created."

    visit "/storelogin"
    fill_in "Storename", with: "testLogin1"
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
  end

  test "store_login" do
    
    visit :storelogin
    fill_in "Storename", with: @store1.storeName
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
    
    visit :storelogin
    fill_in "Storename", with: @store1.storeName
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
  end

  test "add_item_and_user_buy" do
    
    visit :storelogin
    fill_in "Storename", with: @store1.storeName
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"
    
    visit "/add_item"
    fill_in "Name", with: "testAddItem1"
    fill_in "Price", with: 99
    fill_in "Description", with: "testAddItem1Descpt"
    fill_in "Image Source", with: "https://www.freeiconspng.com/uploads/item-configuration-icon-17.png"
    fill_in "Tags", with: "newTag1 testTag2 testTag3"

    click_on "Create Item"

    assert_text "Add Item testAddItem1 successfully!!"

    addedItem1 = Item.last

    visit "/userlogin"
    fill_in "Email", with: @user1.email
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    quantity1 = 2
    for i in quantity1.times
      visit "/add_item_to_bucket/#{addedItem1.id}"
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
    end

    visit :storelogin
    fill_in "Storename", with: @store1.storeName
    fill_in "Password", with: "12345"
    click_on "Login"
    assert_text "Login Successfully"

    tmp_item1 = addedItem1.name
    click_on "Delete", match: :first
    page.driver.browser.switch_to.alert.accept

    visit :storemain
    click_on "Delete", match: :first
    page.driver.browser.switch_to.alert.accept

    visit :storemain
    click_on "Delete", match: :first
    page.driver.browser.switch_to.alert.accept
    assert_text "Delete Item #{tmp_item1} successfully!!"



  end  


  
end
