extends Node2D


signal _endScene

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer
@onready var gameManager: Node = %gameManager

func _ready():
	connect("_endScene", endScene)



func endScene():
	animationPlayer.play("scene_end")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scene_end":
		gameManager.emit_signal("_sceneEnded")
	pass
