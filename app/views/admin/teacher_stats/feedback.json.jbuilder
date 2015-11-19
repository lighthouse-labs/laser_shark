json.direct do
  json.average @overall_stats[:direct_average]
  json.total @overall_stats[:direct_total]  
end

json.lecture do

  json.average @overall_stats[:lecture_average]
  json.total @overall_stats[:lecture_total]

  json.teacher do 
    json.array! @series[:lecture][:teacher] do |day|
      json.array! day
    end
  end

  json.everyone do 
    json.array! @series[:lecture][:everyone] do |day|
      json.array! day
    end
  end

end

json.mentor do

  json.average @overall_stats[:mentor_average]
  json.total @overall_stats[:mentor_total]
  
  json.teacher do 
    json.array! @series[:mentor][:teacher] do |day|
      json.array! day
    end
  end

  json.everyone do 
    json.array! @series[:mentor][:everyone] do |day|
      json.array! day
    end
  end

end
