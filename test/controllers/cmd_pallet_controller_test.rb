require 'test_helper'

class CmdPalletControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get cmd_pallet_index_url
    assert_response :success
  end

  test "should get new" do
    get cmd_pallet_new_url
    assert_response :success
  end

  test "should get create" do
    get cmd_pallet_create_url
    assert_response :success
  end

end
