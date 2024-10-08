extends Node2D

#signal used by the dialogue manager node to start a dialogue sequence
signal _initializeDialogueBox

#signal used by the dialogue manager to show a particular dialogue of a sequence
signal _showDialogue(_name: String, dialogue: String)

#signal used by the dialogue manager to end a dialogue sequence
signal _hideDialogueBox

#animation player node used for dialogue box animations
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer

#main lable that contains the dialogue
@onready var label: Label = $MarginContainer/dialogue

#label that contains the entity name of that dialogue
@onready var entityName: Label = $entityName

#timer
@onready var timer: Timer = $Timer

#the dialogue manager node
@onready var dialogueManager: Node = %dialogueManager

#a sprite2D node that contains the entity face
@onready var face: Sprite2D = $npcFace

#this boolean is used to check if the dialogue box is initialized or not with the _initializeDialogueBox signal if not then the _showDialogue signal won't work
var dialogueRunning = false

#a dictionary for caching entity face sprites
var face_cache = {}

func _ready():

	#connecting the signals with their corresponding handler functions
	connect("_initializeDialogueBox", initializeDialogueBox)
	connect("_showDialogue", showDialogue)
	connect("_hideDialogueBox", hideDialogueBox)


#this function is called when the _initializeDialogueBox signal is emitted. This functions makes the dialogue box visible in the scene and sets the dialogueRunning to true so that the _showDialogue signal can work
func initializeDialogueBox():
	animationPlayer.play("dialogue_box_appear")
	dialogueRunning = true

#this function is called when the _hideDialogueBox signal is emitted. This functions makes the dialogue box invisible and sets the dialogueRunning to false so that the _showDialogue signal won't work until _initializeDialogueBox is emitted again
func hideDialogueBox():
	dialogueRunning = false
	$MarginContainer/Polygon2D.visible = false
	animationPlayer.play("dialogue_box_disappear")

#this function is called when the _showDialogue signal is emitted
func showDialogue(_name: String, dialogue: String):
	var face_texture = null
	entityName.text = ""
	#checks if the entity face sprite exists in the face_cache structure. If does then loads loads from the structure or else loads from the assets
	if face_cache.has(_name):
		face_texture = face_cache[_name]
	else:
		var face_loc: String = "res://Assets/Face/" + _name + ".png"
		face_texture = load(face_loc)
		face_cache[_name] = face_texture
	#sets the entity face sprite
	face.texture = face_texture
	#sets the enitity name
	entityName.text = _name
	#calls this function to show the dialogue letter by letter
	printLetters(dialogue)

#function to show the dialogue letter by letter by iterating through the dialogue string and adding each character one by one with a slight delay
func printLetters(dialogue: String):
	label.text = ""
	animationPlayer.stop()
	$MarginContainer/Polygon2D.visible = false
	if !dialogueRunning:
		return
	for ch in dialogue:
		label.text += ch
		timer.start()
		await timer.timeout
	dialogueManager.emit_signal("_lineCompleted")
	animationPlayer.play("bounce")
