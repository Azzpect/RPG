class_name ResourceManager

#the game data file path
const SAVE_FILE_PATH = "user://data.bin"

#the game data
var gameData = {
	"scene": "",
	"player": PlayerData.new()
}

#saves the game data in the file by converting it in a binary format
func save(scene := "res://scenes/gameScenes/playerRoomScene.tscn", pos := Vector2.ZERO, direction := Vector2.ZERO):
	gameData["scene"] = scene
	gameData["player"] = PlayerData.new(pos, direction)
	var data = {
		"scene": gameData["scene"],
		"player": {
			"position": {
				"x": gameData["player"].position.x,
				"y": gameData["player"].position.y
			},
			"direction": {
				"x": gameData["player"].direction.x,
				"y": gameData["player"].direction.y
			}
		}
	}
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var stringData = convertToBin(JSON.stringify(data))
	file.store_line(stringData)


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
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		print("no data file found...")
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var binaryData = file.get_line().split(" ")
	var data = ""
	#converts the binary data in string format
	for byte in binaryData:
		var byteVal: int = 0
		for i in range(0, 8):
			byteVal += int(byte[i]) * pow(2, 7-i)
		data += char(byteVal)
	var parsedData = JSON.parse_string(data)
	var playerData = parsedData["player"]
	gameData["scene"] = parsedData["scene"]
	gameData["player"] = playerDataFromDict(playerData["position"], playerData["direction"])


func playerDataFromDict(position: Dictionary, direction: Dictionary):
	return PlayerData.new(Vector2(position["x"], position["y"]), Vector2(direction["x"], direction["y"]))
