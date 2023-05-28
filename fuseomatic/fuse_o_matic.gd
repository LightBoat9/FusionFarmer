extends StaticBody2D


var Animal: PackedScene = preload("res://animal/animal.tscn")


@onready var input_left: Node2D = $InputRed
@onready var input_right: Node2D = $InputBlue
@onready var output: Node2D = $Output
@onready var audio_fuse: AudioStreamPlayer2D = $AudioFuse


func process_inputs() -> void:
	if input_left.holding and input_right.holding:
		audio_fuse.play()
		var animal = Animal.instantiate()
		var rand_bool = randi() % 2 == 0
		animal.body = input_left.holding.body if rand_bool else input_right.holding.body
		animal.head = input_right.holding.head if rand_bool else input_left.holding.head
		
		output.drop(animal)
		
		input_right.holding.queue_free()
		input_right.pickup()
		input_left.holding.queue_free()
		input_left.pickup()


func _on_input_red_holding_changed(holding) -> void:
	process_inputs()


func _on_input_blue_holding_changed(holding) -> void:
	process_inputs()
