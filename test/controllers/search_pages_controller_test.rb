require 'test_helper'

class SearchPagesControllerTest < ActionController::TestCase

def setup
  @base_title = "Ginvite"
end

  test "should get home" do
    get :home
    assert_response :success
    assert_select "title", "Home | #{@base_title}"
  end

end
