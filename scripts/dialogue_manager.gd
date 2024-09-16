extends Node


@onready var dialogueBox: MarginContainer = %dialogue_box
@onready var dialogueBoxAnimator: AnimationPlayer = %dialogue_box/AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogueBoxAnimator.play("appear")

func _process(delta):
	if dialogueBox.isDialogueInitialized:
		return
	if !dialogueBoxAnimator.is_playing():
		dialogueBox.initializeDialogue.emit(["hello", "bye"])
		dialogueBox.isDialogueInitialized = true
