extends Node2D
	
	
signal holding_changed(holding)
	
	
var holding: Object = null : set = set_holding
	
	
@export var trailer_index: int = 0
	
	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and (can_drop(interacter) or can_pickup(interacter)))
	
	
func can_drop(holder: Object) -> bool:
	return holder.holding and holder.holding is Animal and not holding and get_parent().is_buy()
	
	
func drop(object: Object) -> void:
	holding = object
	if object.get_parent():
		object.get_parent().remove_child(object)
	add_child(object)
	if holding and "start_animation" in holding:
		holding.start_animation()
	object.set_sprite_flip(false)
	object.set_collision(true)
	object.position = Vector2()
	
	
func set_holding(object: Object) -> void:
	holding = object
	emit_signal("holding_changed", holding)
	
	
func can_pickup(interacter: Object) -> bool:
	return interacter != null and holding and get_parent().trailer_can_interact() and (not get_parent().is_sell() or Global.money >= get_parent().sell_cost)
	
	
func get_pickup() -> Object:
	return holding
	
	
func pickup() -> void:
	if get_parent().is_sell():
		Global.money -= get_parent().sell_cost
	holding = null


func _on_visibility_changed() -> void:
	$CollisionShape2D.disabled = not visible
