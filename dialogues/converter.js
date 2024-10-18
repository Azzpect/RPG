const fs = require("fs")

function convertToHex(data = "") {
    let convertedData = ""
    for(i in data) {
        let code = data.charCodeAt(i)
        let hex = ""
        for(;code > 0; code = Math.floor(code / 16)) {
            let rem = code % 16
            if (rem < 10)
                hex += rem
            else {
                switch (rem) {
                    case 10:
                        hex += "a"
                        break;
                    case 11:
                        hex += "b"
                        break;
                    case 12:
                        hex += "c"
                        break;
                    case 13:
                        hex += "d"
                        break;
                    case 14:
                        hex += "e"
                        break;
                    case 15:
                        hex += "f"
                        break;
                }
            }
        }
        if(hex.length < 2)
            hex += "0"
        convertedData += hex.split("").reverse().join("")
    }
    return convertedData
}

function encrypt(filePath = "", fileName = "") {
    let fileData = fs.readFileSync(filePath, "utf-8")
    for (const line of fileData.split("\n")) {
        let encryptedData = ""
        let hexData = convertToHex(line)
        for(let i = 0; i < hexData.length; i++) {
            encryptedData += String.fromCharCode(hexData.charCodeAt(i) + 130)
        }
        fs.appendFileSync(`${fileName}.crk`, encryptedData)
    }
}

encrypt("./dream2.txt", "dream2")

