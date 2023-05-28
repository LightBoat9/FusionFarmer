extends Node


signal review_added


var turn_cycyle: int = 0
var max_cycle: int = 1
var money: int = 0 : set = set_money
var reviews: Array = []
	
	
const ReviewText = {
	1: ["Terrible", "The worst", "Really bad"],
	2: ["Not great", "Wouldn't Recommend", "Not the best"],
	3: ["Average", "It's OK", "Ordinary"],
	4: ["Pretty good", "Decent", "Acceptable"],
	5: ["Amazing", "Superb", "Excellent", "Impressive", "The Best"]
}
	
	
func _ready() -> void:
	set_money(money)
	
	
func set_money(value: int) -> void:
	money = value
	for label in get_tree().get_nodes_in_group("money_labels"):
		label.text = str(money)
	
	
func add_review(value: int) -> void:
	reviews.append(value)
	for label in get_tree().get_nodes_in_group("review_labels"):
		label.text = "(%d)" % [reviews.size()]
	emit_signal("review_added")

