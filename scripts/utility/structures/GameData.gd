class_name GameData
extends Resource

#the game data file path
const SAVE_FILE_PATH = "user://data.json"

var scene: String = ""
var player: CharacterData = CharacterData.new(Vector2.ZERO, Vector2.ZERO)
var quest: String = "No quest available"

static var gameDataStructure = [
	"scene",
	"player",
	"quest"
]

static var bufferedData: GameData

static func initialize(dict: Dictionary):
	bufferedData = GameData.new()
	if dict.is_empty():
		return
	for key in gameDataStructure:
		if key == "player":
			bufferedData.set(key, CharacterData.playerDataFromDict(dict[key]))
			continue
		bufferedData.set(key, dict[key])
	return

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
	return


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


#saves the game data in the file by converting it in a binary format
static func save(stateData: Dictionary):
	if GameData.isEqual(stateData):
		return
	GameData.update(stateData)
	var data = GameData.convertToDict()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	# var stringData = convertToBin(JSON.stringify(data))
	var stringData = JSON.stringify(data)
	file.store_string(stringData)
	file.close()


#converts given string in binary and returns it
static func convertToBin(data: String) -> String:
	var binaryString = ""
	for i in range(0, data.length()):
		var code = data.unicode_at(i)
		var bin = ""
		for j in range(7, -1, -1):
			bin += str((code >> j) & 1)
		binaryString += bin + " "
	
	return binaryString.trim_suffix(" ")


#loads game data from the file
static func loadData():
	#checks if there is any saved file or not
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify({}))
		file.close()
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	# var binaryData = file.get_line().split(" ")
	# var data = ""
	#converts the binary data in string format
	# for byte in binaryData:
	# 	var byteVal: int = 0
	# 	for i in range(0, 8):
	# 		byteVal += int(byte[i]) * pow(2, 7-i)
	# 	data += char(byteVal)
	var parsedData = JSON.parse_string(file.get_as_text())
	GameData.initialize(parsedData)
	file.close()


func display():
	print({
		"scene": scene,
		"player": {
			"position": player.position,
			"direction": player.direction
		},
		"quest": quest
	})
