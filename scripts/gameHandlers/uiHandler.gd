extends Control

@onready var questBox: NinePatchRect = %questBox
@onready var label: Label = %questBox/MarginContainer/Label
@onready var gameManager: Node = %gameManager

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_quest_pressed() -> void:
	questBox.visible = !questBox.visible
	label.text = gameManager.getQuestDetails()
