extends GameManager

@onready var mother = %mother

func _ready() -> void:
	initialize()
	

func _on_telepoter_3_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/playerRoomScene.tscn", Vector2(585, 394), Vector2(-1, 0), body)


func _on_telepoter_body_entered(body: Node2D) -> void:
	teleport("res://scenes/gameScenes/labRoomScene.tscn", Vector2(437, 329), Vector2(0, 1), body)
