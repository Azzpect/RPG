extends MarginContainer

@onready var label: Label = $MarginContainer/Label
@onready var dialogueManager: Node = %dialogueManager
@onready var timer: Timer = $Timer

@export var isDialogueInitialized = false


signal initializeDialogue(dialogues: Array)




func _ready():
	initializeDialogue.connect(_on_init_dialogue)



func _on_init_dialogue(dialogues: Array):
	for dialogue in dialogues:
		label.text = dialogue
		timer.start()
		await timer.timeout
	
	isDialogueInitialized = false
