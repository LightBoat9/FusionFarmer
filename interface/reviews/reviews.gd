extends VBoxContainer


const TEXTURE_EMPTY = preload("res://interface/reviews/review_star_empty.png")
const TEXTURE_HALF = preload("res://interface/reviews/review_star_half.png")
const TEXTURE_FULL = preload("res://interface/reviews/review_star_full.png")


@onready var average_stars: Control = $HB/HB

@onready var review_text: Control = $ReviewText
@onready var text_label: Label = $ReviewText/VB/Label
@onready var text_stars: Control = $ReviewText/VB/HB
@onready var text_timer: Timer = $TextTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("review_added", _on_review_added)


func _on_review_added() -> void:
	review_text.visible = true
	text_timer.start()
	
	var latest = Global.reviews[-1]
	
	var random_text = Global.ReviewText[latest][randi_range(0, Global.ReviewText[latest].size()-1)]
	
	text_label.text = random_text
	
	for i in range(text_stars.get_child_count()):
		if i+1 <= latest:
			text_stars.get_child(i).texture = TEXTURE_FULL
		elif i+0.5 <= latest:
			text_stars.get_child(i).texture = TEXTURE_HALF
		else:
			text_stars.get_child(i).texture = TEXTURE_EMPTY
			
	var total = 0
	var count = Global.reviews.size()
	
	for i in range(count):
		total += Global.reviews[i]
		
	var average = total / count
	
	for i in range(average_stars.get_child_count()):
		if i+1 <= average:
			average_stars.get_child(i).texture = TEXTURE_FULL
		elif i+0.5 <= average:
			average_stars.get_child(i).texture = TEXTURE_HALF
		else:
			average_stars.get_child(i).texture = TEXTURE_EMPTY
	
	size = Vector2()
	set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT, Control.PRESET_MODE_KEEP_SIZE)


func _on_text_timer_timeout() -> void:
	review_text.visible = false
