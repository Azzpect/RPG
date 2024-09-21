extends Node

signal _lineCompleted
signal _isSpaceClicked


@onready var dialogueBox: Node2D = %dialogue_box
@onready var timer: Timer = $Timer

var dialogues = [
	# "You are a mere mortal, how could you think of defeating me.",
	# "With your fall this world will succumb to darkness and I will become the almighty, the one true king of this world",
	# "No! I won't let that happen",
	# "Ha Ha Ha! You are almost defeated so how are you going to stand against my power.",
	# "I am carrying the hope of all of humanity.",
	# "As long as I don't give up I believe they will lend me their power",
	# "Why don't you wake up now?",
	# "It's almost 10'o clock, Johny, Johny, wake up. The breakfast is ready, wake up quick."
	{"name": "Demon Lord", "dialogue": "You foolish Knight, how could you even think of defeating me."},
	{"name": "Demon Lord", "dialogue": "You are nothing but a mere mortal who wanted to defy the one true King."},
	{"name": "Demon Lord", "dialogue": "With your fall, this world of yours who put all their worthless hope in your being will fall too."},
	{"name": "Demon Lord", "dialogue": "Consumed in darkness and slowly being devoured by this almighty."},
	{"name": "Knight", "dialogue": "I..I won't let that happen."},
	{"name": "Demon Lord", "dialogue": "Ha! You won't let that happen?"},
	{"name": "Demon Lord", "dialogue": "You! Who has fallen on his knees."},
	{"name": "Demon Lord", "dialogue": "Who is barely alive because of the mercy of this True King."},
	{"name": "Knight", "dialogue": "It's true that I am on my knees."},
	{"name": "Knight", "dialogue": "But I still have not fallen."},
	{"name": "Knight", "dialogue": "And I will fight until every fiber of my being ceases to exist."},
	{"name": "Knight", "dialogue": "For I carry the hopes of humanity."},
	{"name": "Demon Lord", "dialogue": "That's commendable!"},
	{"name": "Demon Lord", "dialogue": "But why don't you wake now?"},
	{"name": "Demon Lord", "dialogue": "It's almost 10 o'clock."},
	{"name": "Demon Lord", "dialogue": "You better wake up Sid, and come have your breakfast."},
	{"name": "Knight", "dialogue": "Huh! What are you saying?"}
]
var i = 0
var isSpaceClicked = false
var isLineFinished = false

func _ready():
	connect("_lineCompleted", lineCompleted)
	connect("_isSpaceClicked", spaceClicked)
	timer.start()
	await timer.timeout
	dialogueBox.emit_signal("_initializeDialogueSystem")
	dialogueBox.emit_signal("_showDialogue", dialogues[i]["name"], dialogues[i]["dialogue"])
	i += 1


func _input(event):
	if !isLineFinished:
		return
	if event.is_action_pressed("line_continue"):
		emit_signal("_isSpaceClicked")

func spaceClicked():
	isSpaceClicked = true

func lineCompleted():
	isLineFinished = true
	await _isSpaceClicked
	if(i == dialogues.size()):
		i = 0
		dialogueBox.emit_signal("_hideDialogueBox")
		return
	dialogueBox.emit_signal("_showDialogue", dialogues[i]["name"], dialogues[i]["dialogue"])
	isLineFinished = false
	isSpaceClicked = false
	i += 1
