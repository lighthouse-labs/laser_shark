# Not an ActiveRecord model

class CurriculumDay

  def initialize(date, cohort)
    @date = date
    @cohort = cohort
  end

  def to_s
    days = (@date.to_date - @cohort.start_date).to_i
    w = (days / 7) + 1
    if @date.sunday? || @date.saturday?
      "w#{w}e"
    else
      "w#{w}d#{@date.wday}"
    end
  end

end
