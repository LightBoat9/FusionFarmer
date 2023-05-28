extends Node2D
	
	
var holding: Object = null : set = set_holding
	
	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and can_pickup(interacter))
	
	
func can_drop(holder: Object) -> bool:
	return false#holder.holding and not holding
	
	
func drop(object: Object) -> void:
	if holding:
		holding.get_parent().remove_child(holding)
		get_parent().get_parent().add_child(holding)
		holding.global_position = global_position
		holding.set_collision(false)
		pickup()
	holding = object
	if object.get_parent():
		object.get_parent().remove_child(object)
	add_child(object)
	object.set_collision(true)
	object.position = Vector2()
	
	
func set_holding(object: Object) -> void:
	holding = object
	
	
func can_pickup(interacter: Object) -> bool:
	return holding and interacter != null
	
	
func get_pickup() -> Object:
	return holding
	
	
func pickup() -> void:
	holding = null
