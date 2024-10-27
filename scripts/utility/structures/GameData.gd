class_name GameData
extends Resource

#the game data file path
# const SAVE_FILE_PATH = "user://data.json"
const SAVE_FILE_PATH = "user://state.json"

var scene: String = ""
var player: CharacterData = CharacterData.new(Vector2.ZERO, Vector2.ZERO)
var quest: String = ""

static var gameDataStructure = [
	"scene",
	"player",
	"quest"
]

static var allQuests = {}

static var bufferedData: GameData = GameData.new()

static func store(dict: Dictionary):
	bufferedData = GameData.new()
	for key in gameDataStructure:
		if key == "player":
			bufferedData.set(key, CharacterData.playerDataFromDict(dict[key]))
			continue
		bufferedData.set(key, dict[key])
	loadQuestData()

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
		equal = bufferedData[key] == obj[key]
	return equal


#saves the game data in the file by converting it in a binary format
static func save(stateData: Dictionary):
	if GameData.isEqual(stateData):
		return
	GameData.update(stateData)
	var data = GameData.convertToDict()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	# var stringData = convertToBin(JSON.stringify(data))
	file.store_string(JSON.stringify(data))
	file.close()


#loads game data from the file
static func loadData():
	#checks if there is any saved file or not
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(GameData.convertToDict()))
		file.close()
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var data = file.get_as_text()
	var parsedData = JSON.parse_string(data)
	GameData.store(parsedData)
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


static func loadQuestData():
	var file = FileAccess.open("res://dll/allQuests.json", FileAccess.READ)
	allQuests = JSON.parse_string(file.get_as_text())

static func assignQuest():
	if allQuests[GameData.bufferedData.quest]["status"] == 2:
		var finishedQuest = allQuests.keys().find(GameData.bufferedData.quest)
		var nextQuest = str(int(bufferedData["quest"]) + 1)
		allQuests[nextQuest]["status"] = 1
		GameData.save({"quest": nextQuest})
		saveQuest()

static func saveQuest():
	var file = FileAccess.open("res://dll/allQuests.json", FileAccess.WRITE)
	file.store_string(JSON.stringify(allQuests))

static func reset():
	GameData.save({"scene": "", "player": CharacterData.new(Vector2.ZERO, Vector2.ZERO).convertToDict(), "quest": ""})
	loadQuestData()
	for quest in allQuests:
		allQuests[quest]["status"] = 0
	saveQuest()
	
