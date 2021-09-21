require "test_helper"

class CommnetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @commnet = commnets(:one)
  end

  test "should get index" do
    get commnets_url
    assert_response :success
  end

  test "should get new" do
    get new_commnet_url
    assert_response :success
  end

  test "should create commnet" do
    assert_difference('Commnet.count') do
      post commnets_url, params: { commnet: {  } }
    end

    assert_redirected_to commnet_url(Commnet.last)
  end

  test "should show commnet" do
    get commnet_url(@commnet)
    assert_response :success
  end

  test "should get edit" do
    get edit_commnet_url(@commnet)
    assert_response :success
  end

  test "should update commnet" do
    patch commnet_url(@commnet), params: { commnet: {  } }
    assert_redirected_to commnet_url(@commnet)
  end

  test "should destroy commnet" do
    assert_difference('Commnet.count', -1) do
      delete commnet_url(@commnet)
    end

    assert_redirected_to commnets_url
  end
end
