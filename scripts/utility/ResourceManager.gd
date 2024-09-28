class_name ResourceManager

const SAVE_FILE_PATH = "user://data.bin"

var gameData = {
	"scene": "",
}

func save(data: Dictionary):
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var stringData = convertToBin(JSON.stringify(data))
	file.store_line(stringData)

func loadData():
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		print("no data file found...")
		return
		
	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	var binaryData = file.get_line().split(" ")
	var data = ""
	for byte in binaryData:
		var byteVal: int = 0
		for i in range(0, 8):
			byteVal += int(byte[i]) * pow(2, 7-i)
		data += char(byteVal)
	gameData = JSON.parse_string(data)


func convertToBin(data: String) -> String:
	var binaryString = ""
	for i in range(0, data.length()):
		var code = data.unicode_at(i)
		var bin = ""
		for j in range(7, -1, -1):
			bin += str((code >> j) & 1)
		binaryString += bin + " "
	
	return binaryString.trim_suffix(" ")
