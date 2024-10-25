extends GameManager


func _ready() -> void:
	nextScene = "res://scenes/gameScenes/playerRoomScene.tscn" 
	initialize()
	$"../Timer".start()
	await $"../Timer".timeout
	dialogueBox.emit_signal("_initializeDialogueBox", "cutscene")
	GameData.save({"player": {"position": { "x": 417, "y": 330}, "direction": {"x": 0, "y": -1}}})
	await _endConversation
	sceneEnded()
