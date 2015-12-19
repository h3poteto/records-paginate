class RecordsController < ApplicationController
  def index
    # 既存のkaminari
    @records = Record.order("updated_at DESC").page(params[:page]).per(10)
  end

  def search
    if params[:category_id]
      @guess = GuessPaging::Paginate.new(
        query: Record.where(category_id: params[:category_id].to_i).order('updated_at DESC'),
        per_page: 10)
      @guess.guess(
        page_params: params[:page]
      )
    else
      @guess = GuessPaging::Paginate.new(
        query: Record.order("updated_at DESC"),
        per_page: 10)
      @guess.guess(
        page_params: params[:page]
      )
    end
  end
end
