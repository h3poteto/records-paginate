class RecordsController < ApplicationController
  include GuessPaging
  def index
    # 既存のkaminari
    @records = Record.page(params[:page]).per(10)
  end

  def search
    # 新しいやり方を考える
    # TODO: このオブジェクトを全部ARオブジェクトに載せられればいいのかなぁ
    # helperでARオブジェクトからそれらを取り出せたら最高
    if params[:category_id]
      @records = guess(
        Record.where(category_id: params[:category_id].to_i),
        request.path + '?cateogry=' + params[:category_id],
        params[:page]
      )
    else
      @records = guess(
        Record,
        request.path,
        params[:page]
      )
    end
  end
end
