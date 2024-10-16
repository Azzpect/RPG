extends Control

@onready var questBox: NinePatchRect = %questBox

func _on_button_pressed() -> void:
	get_tree().quit()


func _on_quest_pressed() -> void:
	questBox.visible = !questBox.visible
