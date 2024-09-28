extends Node

@onready var start: Button = %start
@onready var continueGame: Button = %continue

var resourceManager: ResourceManager = ResourceManager.new()
var data: String

func _ready() -> void:
	resourceManager.loadData()
	if resourceManager.gameData["scene"] != "":
		continueGame.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Cutscenes/dream.tscn")


func _on_continue_pressed() -> void:
	get_tree().change_scene_to_file(resourceManager.gameData["scene"])
