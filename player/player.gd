extends CharacterBody2D


const HOLDING_OFFSET: Vector2 = Vector2(0, -4)
const SPEED = 96
var interact_target: Object = null : set = set_interact_target
var interact_collision: bool = false

var holding: Object = null : set = set_holding

@export var animation_offset: Vector2 = Vector2() : set = set_animation_offset

@onready var player_sprites: Array = [
	$SpriteLegs, $SpriteArmsWalk, $SpriteArmsHold, $SpriteArmsHead
]
@onready var sprite_arms_walk: Sprite2D = $SpriteArmsWalk
@onready var sprite_arms_hold: Sprite2D = $SpriteArmsHold

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var shapecast: ShapeCast2D = $ShapeCast2D
@onready var audio_step: AudioStreamPlayer2D = $AudioStep
@onready var audio_pickup: AudioStreamPlayer2D = $AudioPickup
@onready var audio_drop: AudioStreamPlayer2D = $AudioDrop

var _skip_next_move: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		if interact_target:
			if holding and "can_drop" in interact_target and interact_target.can_drop(self):
				var temp = holding
				holding = null
				interact_target.drop(temp)
				audio_drop.play()
			elif not holding and "can_pickup" in interact_target and interact_target.can_pickup(self):
				var pickup_object = interact_target.get_pickup()
				interact_target.pickup()
				if "stop_animation" in pickup_object:
					pickup_object.stop_animation()
				pickup_object.get_parent().remove_child(pickup_object)
				add_child(pickup_object)
				holding = pickup_object
				_skip_next_move = true
				holding.position = HOLDING_OFFSET
				audio_pickup.play()
			elif holding and not interact_collision:
				_drop_holding()
		elif holding and not interact_collision:
			_drop_holding()
			
			
func _drop_holding():
	holding.get_parent().remove_child(holding)
	get_parent().add_child(holding)
	_skip_next_move = true
	var a = shapecast.rotation - PI
	holding.global_position = global_position + (Vector2(16, 16) * Vector2(sin(a), -cos(a)))
	set_deferred("holding", null)
	audio_drop.play()
	
	
func _physics_process(delta: float) -> void:
	if _skip_next_move:
		_skip_next_move = false
	else:
		_handle_movement()
	_handle_animation()
	
	interact_collision = false
	if shapecast.is_colliding():
		var target = null
		var found_target = null
		for i in range(shapecast.get_collision_count()):
			target = shapecast.get_collider(i).get_parent()
			if not target.is_in_group("interactable"):
				interact_collision = true
				break
			if ("can_drop" in target and target.can_drop(self)) or ("can_pickup" in target and target.can_pickup(self)):
				found_target = target
				break
				
		if found_target:
			interact_target = found_target
		else:
			interact_target = null
	else:
		interact_target = null
	
	
func _handle_movement() -> void:
	var dir_input = Vector2()
	
	dir_input.x = (Input.get_action_strength("ui_right") - 
		Input.get_action_strength("ui_left"))
	
	dir_input.y = (Input.get_action_strength("ui_down") - 
		Input.get_action_strength("ui_up"))
		
	dir_input = dir_input.normalized()
	
	if dir_input:
		shapecast.rotation = dir_input.angle() - (PI / 2)
	
	velocity = dir_input * SPEED
	
	move_and_slide()
	
	
func _handle_animation() -> void:
	if velocity.x != 0:
		for sprite in player_sprites:
			sprite.flip_h = velocity.x < 0
	
		if holding:
			holding.sprite_flip = velocity.x < 0
		
	if velocity == Vector2():
		animation.play("idle")
	else:
		animation.play("walk")
		
		
func set_interact_target(value: Object) -> void:
	if interact_target and is_instance_valid(interact_target):
		interact_target.set_highlight(self, false)
		
	interact_target = value
	
	if interact_target:
		interact_target.set_highlight(self, true)
	
	
func set_holding(value: Object) -> void:
	if holding:
		holding.z_index = 0
		holding.set_collision(false)
	
	holding = value
	
	if holding:
		holding.sprite_flip = sprite_arms_walk.flip_h
		holding.z_index = 1
		if "set_collision" in holding:
			holding.set_collision(true)
		sprite_arms_hold.visible = true
		sprite_arms_walk.visible = false
	else:
		sprite_arms_walk.visible = true
		sprite_arms_hold.visible = false
	
	
func set_animation_offset(offset: Vector2) -> void:
	animation_offset = offset
	if holding:
		holding.position = HOLDING_OFFSET + offset
	
	
func play_step() -> void:
	audio_step.pitch_scale = randf_range(0.8, 1.2)
	audio_step.play()
