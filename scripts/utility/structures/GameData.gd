class_name GameData

var scene: String = "res://scenes/Cutscenes/dream.tscn"
var player: CharacterData = CharacterData.new(Vector2.ZERO, Vector2.ZERO)
var quest: String = "No quest available"


func _init(dict: Dictionary = {}):
	if dict.is_empty():
		scene = "res://scenes/Cutscenes/dream.tscn"
		player = CharacterData.new(Vector2.ZERO, Vector2.ZERO)
		quest= "No quest available"
		return
	for key in dict:
		match key:
			"scene":
				scene = dict[key]
			"player":
				player = dict[key]
			"quest":
				quest = dict[key]
