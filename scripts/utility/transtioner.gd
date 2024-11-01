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

