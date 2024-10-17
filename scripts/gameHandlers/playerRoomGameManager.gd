extends GameManager

func _ready() -> void:
	initialize()
	assignQuest("Talk to father in hall room (Press F to interact with the npc")


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/hallRoomScene.tscn", Vector2(908, 466), Vector2(-1, 0), body)
