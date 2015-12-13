class RecordsController < ApplicationController
  def index
    # 既存のkaminari
    @records = Record.page(params[:page]).per(10)
  end

  def search
    # 新しいやり方を考える
    per_page = 10
    page = params[:page] ? params[:page].to_i : 1
    # ここのselectは今までと同じにせざるを得ない
    @records = Record.limit(per_page).offset(per_page * (page - 1))

    # ページ数を初回だけキャッシュする
    # キーは条件で
    # キャッシュした値を有効数字三桁くらいで丸めた（多めに）値を，全件として使用する．
    # 最終ページにアクセスした時には，おそらくそのデータがないので，上手く取得しつつ，ラストページになるように表示を工夫する
    # 最終ページにアクセスした時に，もしまだデータが存在する感じがしたら，このキャッシュ値を更に上げておく

    # 全体ページ数計算
    all_page = RedisClient.get "/search/count"
    if all_page.blank?
      all = Record.count
      all_page = all % per_page == 0 ? all / per_page : (all / per_page + 1)
      RedisClient.set("/search/count", all_page)
    end

    # 適当に丸める桁数
    # : ここあとでconfig設定かinit設定にする
    essential = 2
    count_digit = all_page.to_s.length
    if count_digit > essential
      i = all_page.to_f / (10 ** (count_digit - essential))

      @page_count = (i.ceil * 10 ** (count_digit - essential)).to_i
    end
    @page_count ||= all_page

    # current page
    @current_page = page

    if @records.length < 1
      # この場合は常に最終ページを表示する
      last_page = Record.count / per_page + 1
      if all_page != last_page
        RedisClient.set('/search/count', last_page)
      end
      @records = Record.limit(per_page).offset(per_page * (last_page - 1))
      @current_page = last_page
      @page_count = last_page
    end
  end
end
