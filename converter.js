
const fs = require("fs")

function convertToBinary(payload) {

    let binaryResult = "";

    for(let i = 0; i < payload.length; i++) {
        let charCode = payload.charCodeAt(i);
        let binaryValue = "";


        for(let j = 7; j >= 0; j--) {
            binaryValue += (charCode >> j) & 1;
        }

        binaryResult += binaryValue + " ";
    }

    return binaryResult;
}

let data = { "Atanu Ghosh" : ["hello i am a programmer", "today is very nice", "wow you are beautiful"] }

fs.writeFileSync("data/dialogues/dream.bin", convertToBinary(JSON.stringify(data)))