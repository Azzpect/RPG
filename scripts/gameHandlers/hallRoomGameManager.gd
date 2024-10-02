extends GameManager


func _ready() -> void:
	initialize()


func _on_telepoter_3_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/playerRoomScene.tscn", body)


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/labRoomScene.tscn", body)
