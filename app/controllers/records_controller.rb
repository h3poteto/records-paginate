class RecordsController < ApplicationController
  def index
    # 既存のkaminari
    @records = Record.page(params[:page]).per(10)
  end

  def search
    # 新しいやり方を考える
    @guess_paging = GuessPaging.new(Record.where(category_id: 0), '/search/count/category_id:0')
    @records = @guess_paging.suggestion(params[:page])
  end
end
