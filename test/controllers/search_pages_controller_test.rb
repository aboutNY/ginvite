require 'test_helper'

class SearchPagesControllerTest < ActionController::TestCase
  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | Ginvite"
  end

end
