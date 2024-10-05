class_name CharacterData

var position: Vector2
var direction: Vector2


func _init(pos := Vector2.ZERO, dir := Vector2.ZERO) -> void:
	position = pos 
	direction = dir

func display():
	print("position: ", position)
	print("direction: ", direction)
