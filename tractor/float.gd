extends Control


const FLOAT_SPEED = 128


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_movement(delta)
	
	
func handle_movement(delta: float, align=false) -> void:
	var current_cam = get_viewport().get_camera_2d()
	var viewport_size = get_viewport().size
	var parent_angle = current_cam.global_position.angle_to_point(get_parent().global_position)
	var angle_vec = Vector2(cos(parent_angle), sin(parent_angle))
	var panel_half = size / 2.0
	
	var goal_position = current_cam.global_position + (angle_vec * Vector2(64, 64)) - panel_half
	
	var distance = get_parent().global_position.distance_to(goal_position)
	
	modulate.a = 1.0
	if distance < 80:
		goal_position = get_parent().global_position - Vector2(panel_half.x, size.y) - Vector2(0, 16)
		modulate.a = 0.5
	
	var goal_angle = global_position.angle_to_point(goal_position)
	var goal_vec = Vector2(cos(goal_angle), sin(goal_angle))
	var goal_distance = global_position.distance_to(goal_position)
	
	if align or goal_distance < 4:
		global_position = goal_position
	else:
		global_position += goal_vec * delta * FLOAT_SPEED
