class GuessPaging
  attr_reader :records, :current_page, :max_page, :count
  class << self
    def config(essential: , per_page: )
      @@essential = essential
      @@per_page = per_page
    end
  end

  def initialize(obj, key, per_page=nil)
    @obj = obj
    @key = key
    @per_page = per_page ? per_page : @@per_page
  end

  def page(page_params)
    @records = @obj.limit(@per_page).offset(@per_page * (get_page(page_params) - 1))
  end

  def get_max_page
    max = RedisClient.get(@key).to_i
    if max.blank? || max.zero?
      all = @obj.count
      max = all % @per_page == 0 ? all / @per_page : (all / @per_page + 1)
      RedisClient.set(@key, max)
    end

    count_digit = max.to_s.length
    if count_digit > @@essential
      i = max.to_f / (10 ** (count_digit - @@essential))
      last_page = (i.ceil * 10 ** (count_digit - @@essential)).to_i
    end
    last_page ||= max
  end

  def guess(page_params)
    if page(page_params).length < @per_page
      last_page = @obj.count / @per_page + 1
      RedisClient.set(@key, last_page) if last_page != get_max_page
      @records = @obj.limit(@per_page).offset(@per_page * (last_page - 1))
      @current_page = last_page
      @max_page = last_page
      @count = @obj.count
    else
      @current_page = get_page(page_params)
      @max_page = get_max_page
      @count = @max_page * @per_page
    end
    @records
  end

  def get_page(page_params)
    page_params ? page_params.to_i : 1
  end
end
