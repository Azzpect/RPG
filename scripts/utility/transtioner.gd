extends Node2D

#this signal is used to play the black screen fade in animation at the end of the scene
signal _endScene

#this signal is used to play an blink animation
signal _blink

#animation player node to play animations
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

#the gamemanager node of the scene
@onready var gameManager: Node = %gameManager

func _ready():

	#connecting the signals with their corresponding handler functions
	connect("_endScene", endScene)
	connect("_blink", blink)
	

#this function is called when the _endScene signal is emitted.
func endScene():
	animationPlayer.play("scene_end")

#this function is called when the _blink signal is emitted.
func blink():
	animationPlayer.play("blink")

#this function is called when any animation is finished playing. It checks if the finished animation is the scene_end animation or not. If it was that then it emits _sceneEnded signal of the game manager node
func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "scene_end":
		gameManager.emit_signal("_sceneEnded")
