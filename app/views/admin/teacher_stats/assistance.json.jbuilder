json.daily_stats do
  json.array! @daily_stats do |day|
    json.array! day
  end  
end

json.overall_stats @overall_stats

