class_name Animal
extends CharacterBody2D

const Egg: PackedScene = preload("res://eggs/egg.tscn")
const SPEED = 32


var head: BodyPart : set = set_head
var body: BodyPart : set = set_body
var sprite_flip: bool = false : set = set_sprite_flip


@onready var sprite_body: Sprite2D = $SpriteBody
@onready var sprite_head: Sprite2D = $SpriteHead
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var area_collision: CollisionShape2D = $Area2D/CollisionShape2D
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer
@onready var egg_timer: Timer = $EggTimer


func _ready() -> void:
	animation.play("idle")
	animation.seek(randf_range(0.0, 1.0))
	_on_timer_timeout()
	_set_egg_timer()
	
	
func _physics_process(delta: float) -> void:
	if not collision.disabled:
		move_and_slide()
		if velocity.x != 0:
			set_sprite_flip(velocity.x < 0)
		animation.play("idle")
	
	
func set_head(value: BodyPart) -> void:
	head = value
	_update_sprites()
	
	
func set_body(value: BodyPart) -> void:
	body = value
	_update_sprites()
	
	
func set_highlight(interacter: Object, value: bool) -> void:
	material.set_shader_parameter("outlineVisible", value and can_pickup(interacter))
	
	
func can_pickup(interacter: Object) -> bool:
	return not interacter.holding
	
	
func get_pickup() -> Object:
	return self
	
	
func pickup() -> void:
	pass
	
func start_animation() -> void:
	animation.play("idle")
	
	
func stop_animation() -> void:
	animation.stop()
	sprite_body.frame = 0
	sprite_head.frame = 0
	
	
func set_collision(value: bool) -> void:
	#collision.set_deferred("disabled", value)
	#area_collision.set_deferred("disabled", value)
	collision.disabled = value
	area_collision.disabled = value
		
	$Shadow.visible = not value
	
	
func _update_sprites() -> void:
	$SpriteBody.texture = body.sprite if body else null
	$SpriteHead.texture = head.sprite if head else null
	
	if head and body:
		$SpriteHead.offset = body.anchor - head.anchor + Vector2(0, -8)
	
	
func set_sprite_flip(value: bool) -> void:
	sprite_flip = value
	sprite_head.scale.x = -1 if value else 1
	sprite_body.scale.x = -1 if value else 1


func _on_timer_timeout() -> void:
	timer.wait_time = randf_range(0.25, 2.5)
	timer.start()
	if velocity == Vector2():
		velocity = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * SPEED
	else:
		velocity = Vector2()
	
	
func get_preview() -> Texture:
	var image = Image.create(24, 24, false, Image.FORMAT_RGBA8)
	image.blend_rect(body.sprite.get_image(), Rect2i(12, 12, 24, 24), Vector2i(0, 0))
	image.blend_rect(head.sprite.get_image(), Rect2i(12, 12, 24, 24), body.anchor - head.anchor)
	return ImageTexture.create_from_image(image)
	
	
func _set_egg_timer() -> void:
	egg_timer.start(randf_range(30, 120))
	
	
func _on_egg_timer_timeout() -> void:
	_set_egg_timer()
	if not collision.disabled and body == BodyPartManager.BodyParts.Chicken.Body:
		var egg = Egg.instantiate()
		egg.animal = BodyPartManager.get_animal_name(head)
		get_parent().add_child(egg)
		egg.global_position = global_position
