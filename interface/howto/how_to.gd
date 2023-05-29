extends Control


var page: int = 0 : set = set_page


@onready var pages: Control = $Guide/VBoxContainer/Pages


func _ready() -> void:
	set_page(0)


func set_page(value: int) -> void:
	page = clamp(value, 0, pages.get_child_count()-1)
	for child in pages.get_children():
		child.visible = false
	pages.get_child(page).visible = true


func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://interface/main_menu/main_menu.tscn")
	
	


func _on_next_button_pressed() -> void:
	page += 1


func _on_previous_button_pressed() -> void:
	page -= 1
