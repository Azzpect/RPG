extends GameManager


func _ready() -> void:
	nextScene = "res://scenes/Cutscenes/dream2.tscn" 
	initialize()
	$"../Timer".start()
	await $"../Timer".timeout
	dialogueBox.emit_signal("_initializeDialogueBox", "cutscene")
	await _endConversation
	sceneEnded()
