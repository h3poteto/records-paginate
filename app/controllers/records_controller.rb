class RecordsController < ApplicationController
  def index
    # 既存のkaminari
    @records = Record.page(params[:page]).per(10)
  end

  def search
    # 新しいやり方を考える
    # TODO: このオブジェクトを全部ARオブジェクトに載せられればいいのかなぁ
    # helperでARオブジェクトからそれらを取り出せたら最高
    if params[:category_id]
      @guess = GuessPaging.new(
        query: Record.where(category_id: params[:category_id].to_i),
        per_page: 10)
      @guess.guess(
        page_params: params[:page]
      )
    else
      @guess = GuessPaging.new(
        query: Record,
        per_page: 10)
      @guess.guess(
        page_params: params[:page]
      )
    end
  end
end
