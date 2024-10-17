class_name ResourceManager

#the game data file path
const SAVE_FILE_PATH = "user://data.json"

#the game data
@export var gameData: GameData = GameData.bufferedData

#saves the game data in the file by converting it in a binary format
func save(stateData: Dictionary):
	if GameData.isEqual(stateData):
		gameData = GameData.bufferedData
		return
	gameData = GameData.update(stateData)
	var data = GameData.convertToDict()
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	# var stringData = convertToBin(JSON.stringify(data))
	var stringData = JSON.stringify(data)
	file.store_string(stringData)
	file.close()


#converts given string in binary and returns it
func convertToBin(data: String) -> String:
	var binaryString = ""
	for i in range(0, data.length()):
		var code = data.unicode_at(i)
		var bin = ""
		for j in range(7, -1, -1):
			bin += str((code >> j) & 1)
		binaryString += bin + " "
	
	return binaryString.trim_suffix(" ")


#loads game data from the file
func loadData():
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
	gameData = GameData.initialize(parsedData)
	file.close()
