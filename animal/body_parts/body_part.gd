class_name BodyPart
extends Resource


enum PartType {
	BODY, HEAD
}


@export var sprite: Texture
@export var anchor: Vector2
@export var part_type: PartType = PartType.BODY
