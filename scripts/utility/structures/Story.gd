class_name StoryQuest

static var storyIndex =  -1

static var storyQuests = {
	"gameIntro": {
		"description": "Talk to father in hall room (Press F to interact with the npc",
		"type": "StoryQuest"
	},
	"restForNight": {
		"description": "Go to your bed and wait for night",
		"type": "StoryQuest"
	},
    "talktoAi": {
        
    }
}

static func assignQuest():
	storyIndex += 1
