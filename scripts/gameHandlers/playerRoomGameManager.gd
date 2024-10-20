extends GameManager

func _ready() -> void:
	initialize()
	assignQuest(GameData.questsDict.a1)


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/hallRoomScene.tscn", Vector2(908, 466), Vector2(-1, 0), body)
