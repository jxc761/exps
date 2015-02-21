# change the world coordinate to cammera coordinate

view = Sketchup.active_model.active_view
camera = view.camera

v0 = camera.eye
vn = camera.target - camera.eye
vn = vn.normalize!
vv = camera.up.normalize
vu = vv.cross(vn)
vv = vn.cross(vu)
transf= Geom::Transformation.axes(v0, vu, vv, vn)

left_col, top_row = view.corner 0
right_col, bottom_row = view.corner 3

step = 10

nrows = ( bottom_row - top_row ) / step
ncols = ( right_col - left_col ) / step

xyz = Array.new(nrows){Array.new(ncols)}
uvw = Array.new(nrows){Array.new(ncols)}
 
for i in 0...nrows 
	for j in 0...ncols 
		x = i * step
		y = j * step
		inputpoint = view.inputpoint x, y
		position = inputpoint.position		
		xyz[i][j] = position
		uvw[i][j] = position.transform transf
		
		status = view.draw_points xyz[i][j], 5, 7, "red"
	end
end


#plot out the surface
group = Sketchup.active_model.entities.add_group
entities=group.entities
for i in 0...nrows-1 
	for j in 0...ncols-1
		
		line = [uvw[i][j], uvw[i][j+1]]
		if  uvw[i+1][j+1].on_line? line
			puts i+1, j
		else
			entities.add_face(uvw[i][j], uvw[i][j+1], uvw[i+1][j+1])
		end

		line = [uvw[i][j], uvw[i+1][j]]
		if  uvw[i+1][j+1].on_line? line
			puts i+1, j
		else
			entities.add_face(uvw[i][j], uvw[i+1][j],  uvw[i+1][j+1])
		end
		
	end
end

Sketchup.active_model.entities.add_face(uvw[0][28], uvw[1][28], uvw[1][29])
Sketchup.active_model.entities.add_face(uvw[0][28], uvw[0][29], uvw[1][29])