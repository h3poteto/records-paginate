class RecordsController < ApplicationController
  def index
    # 既存のkaminari
    @records = Record.page(params[:page]).per(10)
  end

  def search
    # 新しいやり方を考える
    @guess_paging = GuessPaging.new(Record, '/search/count')
    @records = @guess_paging.suggestion(params[:page])
  end
end
