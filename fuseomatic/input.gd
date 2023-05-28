extends Node2D
	
	
signal holding_changed(holding)
	
	
var holding: Object = null : set = set_holding
	
	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and (can_drop(interacter) or can_pickup(interacter)))
	
	
func can_drop(holder: Object) -> bool:
	return holder.holding and not holding
	
	
func drop(object: Object) -> void:
	object.get_parent().remove_child(object)
	add_child(object)
	holding = object
	if holding and "start_animation" in holding:
		holding.start_animation()
	object.set_collision(true)
	object.position = Vector2()
	
	
func set_holding(object: Object) -> void:
	holding = object
	emit_signal("holding_changed", holding)
	
	
func can_pickup(interacter: Object) -> bool:
	return interacter != null and not interacter.holding and holding
	
	
func get_pickup() -> Object:
	return holding
	
	
func pickup() -> void:
	holding = null
