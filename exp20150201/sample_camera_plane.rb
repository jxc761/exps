# multi-thread ray testing
def mt_ray_test(rays)
  model = Sketchup.active_model
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


d = 1.0.m
fn_object = "/Users/Jing/Dropbox/3DMotion/exps/exp20150201/data/BatataLata.skp"
# place object into active model
entities = Sketchup.active_model.entities
definitions = Sketchup.active_model.definitions

definition = definitions.load(fn_object)
bbox = definition.bounds
c0 = bbox.corner 0
c7 = bbox.corner 7
rows_span_length = ( c7.z - c0.z).abs
cols_span_length = ( c7.y - c0.y).abs

v1 = Geom::Vector3d.new(1, 0, 0)
v1.length=d
t1 = Geom::Transformation.translation(v1)

v2 =  Geom::Vector3d.new(1, 0, -1)
v2.length = rows_span_length / 2
t2 = Geom::Transformation.translation(v2)]

instance = entities.add_instance(definition, t1*t2)

# set view
view = Sketchup.active_model.active_view
eye = Geom::Point3d.new(0, 0, 0)
up = Geom::Vector3d.new(0, 0, 1)
target = Geom::Point3d.new(d, 0, 0)
view.camera.set(eye, target, up)
view.refresh


# sample points
nrows=256
ncols=256
d_l_row = -rows_span_length * 1.2 / nrows
d_l_col = cols_span_length * 1.2 / ncols
offset_row = rows_span_length * 1.2 / 2
offset_col = cols_span_length * 1.2 / 2

rays = Array.new(nrows){ |i|
  Array.new(ncols) { |j|
     [ Geom::Point3d.new(0, d_l_col * j - offset_col, d_l_row * i + offset_row), Geom::Vector3d.new(1, 0, 0)]
  }
}

items = (0...nrows).collect{ |i|
  puts("processing line: #{i}")
  cur_line = rays[i]
  mt_ray_test(cur_line)
}

# draw
group = Sketchup.active_model.entities.add_group
(0...nrows).step(16).each{ |i|
  (0...ncols).step(16).each{ |j|
    item = items[i][j]
    next unless item
    circle = group.entities.add_circle(item[0], Geom::Vector3d.new(-1, 0, 0), 0.1.cm, 3)
    face = group.entities.add_face(circle)
  }
}
group.material= Sketchup::Color.new("red")


#rays = Array.new(nrows * ncols) {|ind|
#  i = (ind / ncols).floor 
#  j = ind - ncols * i
#  [ Geom::Point3d.new(0, d_l_col * j - offset_col, d_l_row * i + offset_row), Geom::Vector3d.new(1, 0, 0)]
#}
# items = mt_ray_test(rays)
