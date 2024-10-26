class_name GameData
extends Resource

#the game data file path
# const SAVE_FILE_PATH = "user://data.json"
const SAVE_FILE_PATH = "user://state.crk"

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

static func initialize(dict: Dictionary):
	bufferedData = GameData.new()
	if dict.is_empty():
		return
	if dict.keys().size() != gameDataStructure.size():
		return
	for key in dict.keys():
		if not key in gameDataStructure:
			return
		
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
	file.store_string(encrypt(stringData))
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

static func convertToHex(data: String):
	var hexData: String = ""
	for i in data.length():
		var code = data.unicode_at(i)
		var hex: String = ""
		while code > 0:
			var rem = code % 16
			if rem < 10:
				hex += String.num(rem)
			else:
				match rem:
					10:
						hex += "a"
					11:
						hex += "b";
					12:
						hex += "c"
					13:
						hex += "d"	
					14:
						hex += "e"
					15:
						hex += "f"
					_:
						print("default")
			code = code / 16
		if hex.length() < 2:
			hex += "0"
		hexData += hex.reverse()
	return hexData


static func convertHexToStr(hex: String):
	var hexValueDict = {
		"a": 10,
		"b": 11,
		"c": 12,
		"d": 13,
		"e": 14,
		"f": 15
	}
	var stringData = ""
	for div in range(0, hex.length(), 2):
		var hexStr = hex.substr(div, 2)
		var dec = 0
		var i = 1
		for ch in hexStr:
			if ch in hexValueDict.keys():
				dec += hexValueDict[ch] * pow(16, i)
			else:
				dec += int(ch) * pow(16, i)
			i -= 1
		stringData += char(int(dec))
	return stringData


#loads game data from the file
static func loadData():
	#checks if there is any saved file or not
	if not FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
		file.store_string(encrypt(JSON.stringify(GameData.convertToDict())))
		file.close()
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var data = decrypt(file.get_as_text())
	var parsedData = JSON.parse_string(data)
	GameData.initialize(parsedData)
	file.close()

static func encrypt(data: String):
	var hexData = convertToHex(data)
	var encryptedData: String =  ""
	for i in hexData.length():
		encryptedData += char(hexData.unicode_at(i) + 130)
	return encryptedData

static func decrypt(code: String):
	var decryptedData: String = ""
	for i in code.length():
		decryptedData += char(code.unicode_at(i) - 130)
	return convertHexToStr(decryptedData)

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
	if GameData.bufferedData.quest == "" and allQuests["quest1"]["status"] == 0:
		GameData.save({"quest": "quest1"})
		allQuests["quest1"]["status"] = 1
	elif allQuests[GameData.bufferedData.quest]["status"] == 2:
		var finishedQuest = allQuests.keys().find(GameData.bufferedData.quest)
		var nextQuest = allQuests.keys()[finishedQuest+1]
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
	
