extends PanelContainer

const TEXTURE_EMPTY = preload("res://interface/reviews/review_star_empty.png")
const TEXTURE_HALF = preload("res://interface/reviews/review_star_half.png")
const TEXTURE_FULL = preload("res://interface/reviews/review_star_full.png")

@onready var average_stars: Control = $VB/HB
@onready var audio_chaching: AudioStreamPlayer2D = $AudioChaChing


func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_main_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://interface/main_menu/main_menu.tscn")


func _on_visibility_changed() -> void:
	if visible:
		var total = 0
		var count = Global.reviews.size()
		
		average_stars = $VB/HB
		
		if count:
			audio_chaching.play()
			$VB/RetryButton.grab_focus()
			for i in range(count):
				total += Global.reviews[i]
				
			var average = total / count
			
			var random_text = Global.ReviewText[average][randi_range(0, Global.ReviewText[average].size()-1)]
			$VB/Label.text = random_text
			
			for i in range(average_stars.get_child_count()):
				if i+1 <= average:
					average_stars.get_child(i).texture = TEXTURE_FULL
				elif i+0.5 <= average:
					average_stars.get_child(i).texture = TEXTURE_HALF
				else:
					average_stars.get_child(i).texture = TEXTURE_EMPTY
