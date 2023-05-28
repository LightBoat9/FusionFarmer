extends Node2D


signal holding_changed(holding)
	
	
var holding: Object = null : set = set_holding


@onready var texture_progress_bar: TextureProgressBar = $Node2D/TextureProgressBar
@onready var nest_timer: Timer = $NestTimer
	
	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and (can_drop(interacter) or can_pickup(interacter)))
	
	
func can_drop(holder: Object) -> bool:
	return holder.holding and not holding and holder.holding is Egg
	
	
func _process(delta: float) -> void:
	texture_progress_bar.value = (nest_timer.time_left / nest_timer.wait_time) * texture_progress_bar.max_value
	
	
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
	if holding:
		$NestTimer.start()
		$Node2D/TextureProgressBar.visible = true
	else:
		$NestTimer.stop()
		$Node2D/TextureProgressBar.visible = false
	emit_signal("holding_changed", holding)
	

func can_pickup(interacter: Object) -> bool:
	return false
	
	
func get_pickup() -> Object:
	return holding
	
	
func pickup() -> void:
	holding = null


func _on_nest_timer_timeout() -> void:
	if holding:
		var animal = BodyPartManager.Animal.instantiate()
		animal.body = holding.body
		animal.head = holding.head
		animal.global_position = global_position
		get_parent().add_child(animal)
		holding.queue_free()
		pickup()
