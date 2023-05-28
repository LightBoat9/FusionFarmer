extends Node2D



func _ready() -> void:
	$CanvasLayer/Control/PlayButton.grab_focus()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/farm/farm.tscn")
