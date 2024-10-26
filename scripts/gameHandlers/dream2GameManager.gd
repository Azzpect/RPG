extends GameManager


func _ready() -> void:
	nextScene = "res://scenes/gameScenes/playerRoomScene.tscn" 
	initialize()
	get_node("%playerRoom").get_child(0).z_index = 1
	$"../Timer".start()
	await $"../Timer".timeout
	dialogueBox.emit_signal("_initializeDialogueBox", "cutscene")
	GameData.save({"scene": nextScene, "player": {"position": { "x": 322, "y": 247}, "direction": {"x": 0, "y": -1}}})
	await _endConversation
	GameData.assignQuest()
	sceneEnded()
