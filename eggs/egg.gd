class_name Egg
extends Node2D


const ANIMAL_TEXTURES = {
	"Chicken": preload("res://eggs/egg_chicken.png"),
	"Cow": preload("res://eggs/egg_cow.png"),
	"Pig": preload("res://eggs/egg_pig.png")
}


var sprite_flip: bool = false : set = set_sprite_flip
var animal: String = "Chicken" : set = set_animal
var body: BodyPart : 
	get:
		return BodyPartManager.BodyParts[animal].Body
var head: BodyPart : 
	get:
		return BodyPartManager.BodyParts[animal].Head
		
		
@onready var free_timer: Timer = $FreeTimer

	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and can_pickup(interacter))
	
	
func can_pickup(interacter: Object) -> bool:
	return not interacter.holding
	
	
func get_pickup() -> Object:
	return self
	
	
func pickup() -> void:
	pass
	
	
func set_sprite_flip(value: bool) -> void:
	sprite_flip = value
	pass
	
	
func set_collision(value: bool) -> void:
	if value:
		free_timer.stop()
	else:
		free_timer.start()
	$Area2D/CollisionShape2D.disabled = value
	
	
func set_animal(value: String) -> void:
	animal = value
	$Sprite2D.texture = ANIMAL_TEXTURES[animal]


func _on_timer_timeout() -> void:
	queue_free()
