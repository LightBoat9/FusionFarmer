class_name BodyPartManager
extends Object


const Animal: PackedScene = preload("res://animal/animal.tscn")


const BodyParts: Dictionary = {
	"Chicken": {
		"Body": preload("res://animal/body_parts/chicken/chicken_body.tres"),
		"Head": preload("res://animal/body_parts/chicken/chicken_head.tres")
	},
	"Pig": {
		"Body": preload("res://animal/body_parts/pig/pig_body.tres"),
		"Head": preload("res://animal/body_parts/pig/pig_head.tres")
	},
	"Cow": {
		"Body": preload("res://animal/body_parts/cow/cow_body.tres"),
		"Head": preload("res://animal/body_parts/cow/cow_head.tres")
	}
}
	
	
static func get_animal(body, head) -> Object:
	var animal = Animal.instantiate()
	animal.body = BodyParts[body].Body
	animal.head = BodyParts[head].Head
	return animal
	
	
static func get_animal_name(part) -> String:
	for animal in BodyParts:
		for type in BodyParts[animal]:
			if BodyParts[animal][type] == part:
				return animal
				
	return ""
		
