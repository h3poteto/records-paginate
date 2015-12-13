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
      @guess_paging = GuessPaging.new(
        Record.where(category_id: params[:category_id].to_i),
        request.path + '?cateogry=' + params[:category_id])
    else
      @guess_paging = GuessPaging.new(
        Record,
        request.path)
    end
    @records = @guess_paging.suggestion(params[:page])
  end
end
