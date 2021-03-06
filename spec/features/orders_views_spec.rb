require 'rails_helper'

RSpec.describe "Orders views", type: :feature do

  before(:each) do
    @order = create(:order)
    @user = create(:user_with_facebook)
    meal_user = create(:user_with_facebook)
    @meal = Meal.create!(name: "meal1", price: "10", order: @order, user: meal_user)
  end

  scenario 'new order clicked when unauthorized' do
    visit '/'
    alert = accept_alert do
      click_button('Add')
    end

    expect(alert).to eq("Please log in to continue")
  end

  scenario 'new order clicked with no name given' do
    visit '/'
    page.execute_script("localStorage.facebook_token = '#{@user.access_token}'")
    alert = accept_alert do
      click_button('Add')
    end

    expect(alert).not_to be_empty
  end

  scenario 'order link clicked when authorized' do
    visit '/'
    page.execute_script("localStorage.facebook_token = '#{@user.access_token}'")
    list = find('#active-orders-list').all('li')
    fill_in("order-name-field", with: "new_order")
    click_button('Add')

    expect(find('#active-orders-list').all('li').count).to eq(list.count + 1)
  end

  scenario 'an order was clicked' do
    visit '/'
    page.execute_script("localStorage.facebook_token = '#{@user.access_token}'")
    visit '/#/orders/'
    click_link(@order.name)
    expect(page).to have_content("Name: #{@order.name}")
    expect(page).to have_button("Finalize order")
    expect(page).to have_content(@meal.name)
  end

  scenario 'adding meal to an order and updating its status' do
    visit '/'
    page.execute_script("localStorage.facebook_token = '#{@user.access_token}'")

    visit "/#/orders/#{@order.id}"
    order_meals = find("#order-meals").all("tr")
    fill_in "name", with: "new_meal"
    fill_in "price", with: "100"
    click_button "Add your meal"
    expect(find("#order-meals").all("tr").count).to eq(order_meals.count + 1)
    click_button "Finalize order"
    expect(page).not_to have_button("Add your meal")
    expect(page).to have_button("Mark as ordered")
    click_button "Mark as ordered"
    expect(page).to have_button("Mark as delivered")

    active_orders_count = find('#active-orders-list').all('li').count
    click_link "History"
    delivered_orders_count = find('#delivered-orders-list').all('li').count

    click_button "Mark as delivered"
    expect(page).to have_button('Delivered', disabled: true)

    click_link "Active"
    expect(find('#active-orders-list').all('li').count).to eq(active_orders_count - 1)
    click_link "History"
    expect(find('#delivered-orders-list').all('li').count).to eq(delivered_orders_count + 1)
  end

  scenario 'trying to add two meals to an order' do
    visit '/'
    page.execute_script("localStorage.facebook_token = '#{@user.access_token}'")
    visit "/#/orders/#{@order.id}"
    fill_in "name", with: "new_meal"
    fill_in "price", with: "100"
    click_button "Add your meal"
    fill_in "name", with: "new_meal2"
    fill_in "price", with: "150"
    alert = accept_alert do
      click_button "Add your meal"
    end
    expect(alert).to eq("Validation failed: User already has a meal in this order")
  end
end
