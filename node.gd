extends Node

var fileLoc: String = "res://dialogues/hall.txt"

func _ready() -> void:
	var file = FileAccess.open(fileLoc, FileAccess.READ)
	while not file.eof_reached():
		var line = file.get_line().trim_prefix(" ").trim_suffix(" ")
		if line == "" or line.begins_with("*"):
			continue
		print(line.split(": "))
