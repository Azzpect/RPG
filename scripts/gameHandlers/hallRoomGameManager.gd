extends GameManager

@onready var mother = %mother

func _ready() -> void:
	initialize()
	# assignQuest("return to room")
	readDialogueFile("res://dll/hall.gd")
	await _performBlink
	player.lastDirection = Vector2(0, 1)
	player.position.x = 230
	player.position.y = 515
	player.get_child(0).disabled = true
	%mother.position.x = 218
	%mother.position.y = 345
	%mother/Sprite2D.texture = load("res://Assets/characters/mother_back.png")
	%mother/CollisionShape2D.disabled = true
	await dialogueBox._dialogueCompleted
	emit_signal("_performBlink")
	player.position.y = 460
	player.get_child(0).disabled = false
	player.speed = 70
	%mother.position.x = 231
	%mother.position.y = 488
	%mother/Sprite2D.texture = load("res://Assets/characters/mother_front.png")


func _on_telepoter_3_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/playerRoomScene.tscn", Vector2(678, 480), Vector2(-1, 0), body)


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/labRoomScene.tscn", Vector2(437, 329), Vector2(0, 1), body)
