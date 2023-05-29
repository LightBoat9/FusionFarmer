extends Node2D



func _ready() -> void:
	$CanvasLayer/Control/VBoxContainer/PlayButton.grab_focus()


func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/farm/farm.tscn")


func _on_how_to_button_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/howto/how_to.tscn")
