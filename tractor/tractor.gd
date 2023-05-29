extends StaticBody2D


enum Mode {
	IDLE, ENTER, LEAVE, BUY, SELL
}

const REVIEW_LOOKUP = {
	1: {
		0: [1, 2],
		1: [5, 5]
	},
	2: {
		0: [1, 2],
		1: [2, 4],
		2: [5, 5]
	},
	3: {
		0: [1, 2],
		1: [2, 3],
		2: [3, 4],
		3: [5, 5]
	}
}

const SPEED = 64.0

@export var mode: Mode = Mode.ENTER : set = set_mode
var buy_animals: Array = []

@onready var thoughtbox = $ThoughtBox
@onready var thought_textures: Control = $ThoughtBox/HB/Buy
@onready var thought_buy: Control = $ThoughtBox/HB/Buy
@onready var thought_sell: Control = $ThoughtBox/HB/Sell
@onready var trailers: Array = [
	$Trailer1,
	$Trailer2,
	$Trailer3,
]
@onready var progress_timer: Timer = $ProgressTimer
@onready var progress_bar: TextureProgressBar = $ThoughtBox/HB/TextureProgressBar
@onready var audio_chaching: AudioStreamPlayer2D = $AudioChaChing

var _is_buy = true
var sell_cost = 5

func _ready() -> void:
	set_deferred("mode", mode)
	
	
func trailer_can_interact() -> bool:
	return mode in [Mode.BUY, Mode.SELL]
	
	
func _update_float() -> void:
	for i in range(thought_textures.get_child_count()):
		thought_textures.get_child(i).get_node("Check").visible = false
		
	for i in range(thought_textures.get_child_count()):
		var tex = thought_textures.get_child(i).get_node("Icon")
		var check = thought_textures.get_child(i).get_node("Check")
		tex.visible = i < buy_animals.size()
		
		if i < buy_animals.size():
			tex.texture = buy_animals[i].get_preview()
	
	for t in range(trailers.size()):
		for i in range(buy_animals.size()):
			var check = thought_textures.get_child(i).get_node("Check")
			if trailers[t].visible and trailers[t].holding and _animals_match(trailers[t].holding, buy_animals[i]) and not check.visible:
				check.visible = true
				break
		
	"""
	var has_all_checks = true
	for i in range(buy_animals.size()):
		var check = thought_textures.get_child(i).get_node("Check")
		if not check.visible:
			has_all_checks = false
			break
			
	if mode == Mode.BUY and has_all_checks:
		progress_timer.stop()
		mode = Mode.LEAVE
	"""
	
	thoughtbox.size = Vector2()
				
			
func _animals_match(anim1, anim2) -> bool:
	return anim1.body == anim2.body and anim1.head == anim2.head
	
	
func _process(delta: float) -> void:
	progress_bar.value = ((progress_timer.time_left / progress_timer.wait_time) * progress_bar.max_value)
	

func _on_trailer_holding_changed(holding: Object, _trailer_index: int) -> void:
	_update_float()
	
	
func set_mode(value: Mode) -> void:
	mode = value
	
	if mode == Mode.ENTER:
		_set_random_buy()
		for i in range(trailers.size()):
			if trailers[i].holding:
				trailers[i].holding.queue_free()
				trailers[i].pickup()
		if not _is_buy:
			_set_random_sell()
		thoughtbox.visible = false
		var tween = create_tween()
		var start = Vector2(-26, 16.5)*Vector2(16, 16)
		var end = Vector2(0, 16.5)*Vector2(16, 16)
		var distance = start.distance_to(end)
		global_position = start
		tween.tween_property(self, "global_position", end, distance * (1.0 / SPEED))
		await tween.finished
		if _is_buy:
			set_mode(Mode.BUY)
		else:
			set_mode(Mode.SELL)
	elif mode == Mode.BUY:
		thought_buy.visible = true
		thought_sell.visible = false
		thoughtbox.size = Vector2()
		if buy_animals.size() == 1:
			progress_timer.start(20)
		else:
			progress_timer.start(buy_animals.size() * 15)
		thoughtbox.position = Vector2()
		thoughtbox.handle_movement(0, true)
		thoughtbox.visible = true
	elif mode == Mode.LEAVE:
		if _is_buy:
			var check_count = 0
			for t in range(trailers.size()):
				for i in range(buy_animals.size()):
					var check = thought_textures.get_child(i).get_node("Check")
					if trailers[t].visible and trailers[t].holding and _animals_match(trailers[t].holding, buy_animals[i]):
						check_count += 1
						Global.money += 10
						break
						
			if check_count > 0:
				audio_chaching.play()
						
			var review_range = REVIEW_LOOKUP[buy_animals.size()][check_count]
			Global.add_review(randi_range(review_range[0], review_range[1]))
						
		thoughtbox.visible = false
		var tween = create_tween()
		var start = Vector2(0, 16.5)*Vector2(16, 16)
		var end = Vector2(26, 16.5)*Vector2(16, 16)
		var distance = start.distance_to(end)
		global_position = start
		tween.tween_property(self, "global_position", end, distance * (1.0 / SPEED))
		await tween.finished
		if _is_buy and Global.turn_cycyle >= Global.max_cycle - 1:
			for node in get_tree().get_nodes_in_group("end_popup"):
				node.visible = true
			get_tree().paused = true
		else:
			_is_buy = not _is_buy
			set_mode(Mode.ENTER)
	elif mode == Mode.SELL:
		if Global.turn_cycyle < 3:
			sell_cost = 5
		elif Global.turn_cycyle < 6:
			sell_cost = 10
		else:
			sell_cost = 15
			
		for label in get_tree().get_nodes_in_group("sell_label"):
			label.text = str(sell_cost)
		thought_buy.visible = false
		thought_sell.visible = true
		thoughtbox.size = Vector2()
		progress_timer.start(15)
		thoughtbox.position = Vector2()
		thoughtbox.handle_movement(0, true)
		thoughtbox.visible = true
		Global.turn_cycyle += 1
		
		
func _set_random_buy() -> void:
	buy_animals = []
	
	var buy_count = 1
	if Global.turn_cycyle < 3:
		buy_count = 1
	elif Global.turn_cycyle < 6:
		buy_count = 2
	else:
		buy_count = 3
	
	for i in range(buy_count):
		var animals = BodyPartManager.BodyParts.keys()
		buy_animals.append(BodyPartManager.get_animal(animals[randi_range(0, animals.size()-1)], animals[randi_range(0, animals.size()-1)]))
	
	for i in range(trailers.size()):
		trailers[i].visible = i < buy_animals.size()
		
	_update_float()


func _on_progress_timer_timeout() -> void:
	if mode in [Mode.BUY, Mode.SELL]:
		mode = Mode.LEAVE
	
	
func _set_random_sell() -> void:
	var animals = BodyPartManager.BodyParts.keys()
	for i in range(trailers.size()):
		trailers[i].visible = true
#		var rand = animals[randi_range(0, animals.size()-1)]
#		if i == 0:
#			rand = "Chicken" # Always give 1 chicken
		trailers[i].drop(BodyPartManager.get_animal(animals[i], animals[i]))
	
	
func is_buy() -> bool:
	return mode == Mode.BUY
	
	
func is_sell() -> bool:
	return mode == Mode.SELL
