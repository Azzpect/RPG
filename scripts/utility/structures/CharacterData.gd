class_name CharacterData

var position: Vector2
var direction: Vector2


func _init(pos := Vector2.ZERO, dir := Vector2.ZERO) -> void:
	position = pos 
	direction = dir

func isEqual(obj):
	if obj is CharacterData:
		return self.position == obj.position && self.direction == obj.direction
	elif obj is Dictionary:
		return self.isEqual(playerDataFromDict(obj))

func convertToDict():
	return {
		"position": {
			"x": self.position.x,
			"y": self.position.y,
		},
		"direction": {
			"x": self.direction.x,
			"y": self.direction.y,
		}
	}

static func playerDataFromDict(playerData: Dictionary):
	return CharacterData.new(Vector2(playerData["position"]["x"], playerData["position"]["y"]), Vector2(playerData["direction"]["x"], playerData["direction"]["y"]))

func display():
	print("position: ", position)
	print("direction: ", direction)
