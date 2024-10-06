extends GameManager


func _ready() -> void:
	initialize()
	


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/hallRoomScene.tscn", Vector2(903, 392), Vector2(0, 1), body)
