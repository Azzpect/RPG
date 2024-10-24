class_name DialogueData


static var sceneDialogues = {}


static func update(_name, arr) -> void:
	if not _name in sceneDialogues:
		sceneDialogues[_name] = []
	sceneDialogues[_name].append(arr)
