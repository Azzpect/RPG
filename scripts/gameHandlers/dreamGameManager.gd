extends GameManager


func _ready() -> void:
	nextScene = "res://scenes/gameScenes/playerRoomScene.tscn" 
	initialize()
	$"../Timer".start()
	await $"../Timer".timeout
	dialogueBox.emit_signal("_initializeDialogueBox", dialogueObj["cutscene"])
	await _endConversation
	GameData.save({"quest": "1"})
	teleport(nextScene, Vector2(325, 250), Vector2(0, -1))
