# multiple threads ray testing
def mt_ray_test(rays, model)
  
  # model = Sketchup.active_model
  n = rays.length
  
  items = Array.new(n){nil}
  threads = Array.new(n){nil}
  
  
  n.times do |i|
      threads[i] = Thread.new{
        items[i] = model.raytest(rays[i])
      }
  end
  
  threads.each { |thr| thr.join }
  
  return items
end
