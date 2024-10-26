extends Node

#start new game button
@onready var start: Button = %start

#continue button to start the where left
@onready var continueGame: Button = %continue


func _ready() -> void:
	#loading the saved game data
	GameData.loadData()
	#checks if the load_data has any record of the previous scene if yes then makes the continue button visible
	if GameData.bufferedData.scene != "":
		continueGame.visible = true

#is called when the start button is pressed. Loads the first cutscene of the game
func _on_start_pressed() -> void:
	GameData.reset()
	get_tree().change_scene_to_file("res://scenes/Cutscenes/dream1.tscn")

#is called when the continue button is pressed. Loads the scene saved in game data file
func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(GameData.bufferedData.scene)
