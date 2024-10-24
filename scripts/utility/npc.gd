extends CharacterBody2D

var npcName = "random guy"
var dialogues = [
	["hello i am here", "hello you are there"], 
	["who are you", "do i know you"],
]

func _ready() -> void:
	print(randi() % dialogues.size())
