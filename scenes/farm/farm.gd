extends Node2D


const Animal: PackedScene = preload("res://animal/animal.tscn")
const PigBody: BodyPart = preload("res://animal/body_parts/pig/pig_body.tres")
const PigHead: BodyPart = preload("res://animal/body_parts/pig/pig_head.tres")
const ChickenBody: BodyPart = preload("res://animal/body_parts/chicken/chicken_body.tres")
const ChickenHead: BodyPart = preload("res://animal/body_parts/chicken/chicken_head.tres")
const CowBody: BodyPart = preload("res://animal/body_parts/cow/cow_body.tres")
const CowHead: BodyPart = preload("res://animal/body_parts/cow/cow_head.tres")


func _ready() -> void:
	randomize()
	var r = randi()
	print("Seed: %d" % r)
	seed(r)
	
	var animal = null
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(-7, 1) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = PigBody
		animal.head = PigHead
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(-7, 5) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = ChickenBody
		animal.head = ChickenHead
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(-7, 9) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = CowBody
		animal.head = CowHead
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(7, 1) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = PigBody
		animal.head = PigHead
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(7, 5) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = ChickenBody
		animal.head = ChickenHead
	
	for i in range(2):
		animal = Animal.instantiate()
		animal.global_position = Vector2(7, 9) * Vector2(16, 16) + Vector2(-16 + i * 24, 0)
		add_child(animal)
		animal.body = CowBody
		animal.head = CowHead
