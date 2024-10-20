class_name GameData
extends Resource

var scene: String = ""
var player: CharacterData = CharacterData.new(Vector2.ZERO, Vector2.ZERO)
var quest: String = "No quest available"


static var gameDataStructure = [
	"scene",
	"player",
	"quest"
]

#Quest Dictionary
static var questsDict = {
	"a1": "Talk to father in hall room (Press F to interact with the NPC)",
	"a2": "Return to room"
}

static var bufferedData: GameData

static func initialize(dict: Dictionary):
	bufferedData = GameData.new()
	if dict.is_empty():
		return bufferedData
	for key in gameDataStructure:
		if key == "player":
			bufferedData.set(key, CharacterData.playerDataFromDict(dict[key]))
			continue
		bufferedData.set(key, dict[key])
	return bufferedData

static func update(dict: Dictionary):
	for key in gameDataStructure:
		if key in dict:
			if key == "player":
				if not bufferedData.player.isEqual(dict[key]):
					if dict[key] is Dictionary:
						bufferedData.player = CharacterData.playerDataFromDict(dict[key])
						continue
					bufferedData.player = dict[key]
				continue
			if bufferedData.get(key) != dict[key]:
				bufferedData.set(key, dict[key])
	return bufferedData


static func convertToDict():
	return {
		"scene": bufferedData.scene,
		"player": bufferedData.player.convertToDict(),
		"quest": bufferedData.quest
	}


static func isEqual(obj: Dictionary):
	var equal = false
	for key in obj:
		if key == "player":
			equal = bufferedData.player.isEqual(obj[key])
			continue
		equal = bufferedData[key] == obj.get(key, null)
	return equal


func display():
	print({
		"scene": scene,
		"player": {
			"position": player.position,
			"direction": player.direction
		},
		"quest": quest
	})
