module ApplicationHelper
  def paging(guess)
    hash = request.params
    hash.delete(:controller)
    hash.delete(:action)
    div = content_tag(:div, class: 'paging') do
      content_tag(:ul) do
        if guess.current_page < 5
          # 先頭
          first_paging(guess, hash)
        elsif guess.current_page > guess.max_page - 4
          last_paging(guess, hash)
          # ラスト
        else
          # 中間
          middle_paging(guess, hash)
        end
      end
    end
    div.html_safe
  end

  def first_paging(guess, hash)
    li = ""
    (1..4).each do |i|
      li << if i == guess.current_page
              content_tag(:li, class: 'active') do
                "#{i}"
              end
            else
              content_tag(:li) do
                link_to("#{i}", search_records_path(hash.merge(page: i)))
              end
            end
    end
    li << content_tag(:li, class: 'truncate') do
      "..."
    end
    li <<  content_tag(:li, class: 'last') do
      link_to("#{guess.max_page}", search_records_path(hash.merge(page: guess.max_page)))
    end
    li.html_safe
  end

  def last_paging(guess, hash)
    li = content_tag(:li) do
      link_to("1", search_records_path(hash.merge(page: 1)))
    end
    li << content_tag(:li, class: 'truncate') do
      "..."
    end
    ((guess.max_page - 3)..guess.max_page).each do |i|
      li << if i == guess.current_page
              content_tag(:li, class: 'active') do
                "#{i}"
              end
            else
              content_tag(:li) do
                link_to("#{i}", search_records_path(hash.merge(page: i)))
              end
            end
    end
    li.html_safe
  end

  def middle_paging(guess, hash)
    li = content_tag(:li) do
      link_to("1", search_records_path(hash.merge(page: 1)))
    end
    li << content_tag(:li, class: 'truncate') do
      "..."
    end
    ((guess.current_page - 2)..(guess.current_page + 2)).each do |i|
      li << if guess.current_page == i
              content_tag(:li, class: 'active') do
                "#{i}"
              end
            else
              content_tag(:li) do
                link_to("#{i}", search_records_path(hash.merge(page: i)))
              end
            end
    end
    li << content_tag(:li) do
      "..."
    end
    li << content_tag(:li) do
      link_to("#{guess.max_page}", search_records_path(hash.merge(page: guess.max_page)))
    end
    li.html_safe
  end
end
