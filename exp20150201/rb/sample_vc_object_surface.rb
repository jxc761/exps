# load("/Users/Jing/Dropbox/exps/exp20150201/sample_vc_object_surface.rb")

require "#{File.dirname(__FILE__)}/utils.rb"

d 		= 1.0.m
nrows	= 256
ncols	= 256
resume 	= true

cur_dir  = File.dirname(__FILE__)

input_dir = File.join(File.dirname(cur_dir), "share", "objects") 
fn_objects = Dir[File.join(input_dir, "*.skp")]
cur_dir  = File.dirname("/Users/Jing/Dropbox/exps/exp20150201/sample_vc_object_surface.rb")
output_dir =File.join(cur_dir, "cached", "view_centered_surface")
unless resume
	system("rm -r #{output_dir}")
end

unless File.directory?(output_dir)
	system("mkdir -p #{output_dir}")
end 

# display current setting
puts("-------------------------------------------------------")
puts("d(eye, target) : ${d}")
puts("		      w  : ${ncols}")
puts("			  h  : ${nrows}")
puts("         Input : ${input_dir}")
puts("        Output : ${output_dir}")
puts("       Resume? : #{resume}")
puts("-------------------------------------------------------")
# fn_object = "/Users/Jing/Dropbox/3DMotion/exps/exp20150201/data/BatataLata.skp"
fn_objects.each{ |fn_object|

	
	basename = File.basename(fn_object, ".skp")
	output = File.join(output_dir, "#{basename}.txt")
	
	if File.file?(output)
		puts("skip object: #{basename}")
		next
	else
		puts("processing object: #{basename}")
	end
	
	# clear model
	Sketchup.active_model.entities.clear!
    Sketchup.active_model.materials.purge_unused
	Sketchup.active_model.definitions.purge_unused
	
	
	# place object into active model
	model = Sketchup.active_model
	entities = Sketchup.active_model.entities
	definitions = Sketchup.active_model.definitions

	definition = definitions.load(fn_object)
	bbox = definition.bounds
	c0 = bbox.corner 0
	c7 = bbox.corner 7
	rows_span_length = ( c7.z - c0.z).abs
	cols_span_length = ( c7.y - c0.y).abs
	
	rotation = Geom::Transformation.rotation  Geom::Point3d.new(1, 0, 0),  Geom::Vector3d.new(0, 0, 1), 45.degrees
	
	v1 = Geom::Vector3d.new(1, 0, 0)
	v1.length=d
	t1 = Geom::Transformation.translation(v1)

	v2 =  Geom::Vector3d.new(1, 0, -1)
	v2.length = rows_span_length / 2
	t2 = Geom::Transformation.translation(v2)
	
	
	instance = entities.add_instance(definition, t2 * t1 *rotation)

	# set view
	view = Sketchup.active_model.active_view
	eye = Geom::Point3d.new(0, 0, 0)
	up = Geom::Vector3d.new(0, 0, 1)
	target = Geom::Point3d.new(d, 0, 0)
	view.camera.set(eye, target, up)
	view.refresh

	fn_img = File.join(output_dir, "#{basename}.png")
	view.write_image(fn_img, ncols, nrows, true)
	
	# sample points
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
      if i % 16 == 0
      	puts("please waiting, processing line: #{i}")
      end  
	  cur_line = rays[i]
	  mt_ray_test(cur_line, model)
	}
	
	

	#draw
	#group = Sketchup.active_model.entities.add_group
	#(0...nrows).step(16).each{ |i|
	#  (0...ncols).step(16).each{ |j|
	#    item = items[i][j]
	#    next unless item
	#    circle = group.entities.add_circle(item[0], Geom::Vector3d.new(-1, 0, 0), 0.1.cm, 3)
	#    face = group.entities.add_face(circle)
	#  }
	#}
	#group.material= Sketchup::Color.new("red")

	#save out the results
	file = File.open(output, "w")
	X = items.collect{|line|
		line.collect{|item|
			item ? "#{item[0].x.to_f}" : "NAN"
		}
	}
	
	Y = items.collect{|line|
		line.collect{|item|
			item ? "#{item[0].y.to_f}" : "NAN"
		}
	}
	
	Z = items.collect{|line|
		line.collect{|item|
			item ? "#{item[0].z.to_f}" : "NAN"
		}
	}
	X.each{|line| file.puts(line.join("\t"))}
	Y.each{|line| file.puts(line.join("\t"))}
	Z.each{|line| file.puts(line.join("\t"))}
	
	file.close()
	
	
}

