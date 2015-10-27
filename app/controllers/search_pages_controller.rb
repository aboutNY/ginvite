class SearchPagesController < ApplicationController
  def home
    # @gig = Gig.new
    #ViewのFormで取得したパラメータをモデルに渡す
    @gig = Gig.search(params[:search])
  end
  def list
    @gig = Gig.all
  end
  def contact
  end
end
