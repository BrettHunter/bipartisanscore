def filter
ary = Array.new
Legislatorscore.all.each do |obj|
  if obj.legislator == []
    ary.push(obj.id)
  end  
end
return ary
end

filter

   
    
  