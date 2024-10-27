@export var sceneDialogues = {
	"cutscene": "
			Demon Lord: You foolish Knight, how could you even think of defeating me.
			Demon Lord: You are nothing but a mere mortal who wanted to defy the one true King.
			Demon Lord: With your fall, this world of yours who put all their worthless hope in your being will fall too.
			Demon Lord: Consumed in darkness and slowly being devoured by this almighty.
			[::]
			/get background
			/set background texture load(res://Assets/cutscene/castleKnight.png)
			Knight: I..I won't let that happen.
			[::]
			/set background texture load(res://Assets/cutscene/castledemon.png)
			Demon Lord: Ha! You won't let that happen?
			Demon Lord: You! Who has fallen on his knees.
			Demon Lord: Who is barely alive because of the mercy of this True King.
			[::]
			/set background texture load(res://Assets/cutscene/castleKnight.png)
			Knight: It's true that I am on my knees.
			Knight: But I still have not fallen.
			Knight: And I will fight until every fiber of my being ceases to exist.
			Knight: For I carry the hopes of humanity.
			[::]
			/set background texture load(res://Assets/cutscene/castledemon.png)
			Demon Lord: That's commendable!
			Demon Lord: But why don't you wake up now?
			Demon Lord: It's almost 10 o'clock.
			Demon Lord: You better wake up Sid, and come have your breakfast.
			[::]
			/set background texture load(res://Assets/cutscene/castleKnight.png)
			Knight: Huh! What are you saying?
			[::]
			/get camera
			/set camera zoom 2,2
			/get dialogueBox
			/set dialogueBox scale 0.5,0.5
			/set dialogueBox position 463,504
			/set background visible false
			/get playerRoom
			/set playerRoom visible true
			Sid: What happened? Where is Demon Lord?
			Mother: What Demon? If you don't wake quickly, I will show what an actual demon is.
			Mother: Go wash your face and come down, your father is already there.
			Sid: Oh! Ok Mom, I will be there in a few minutes.
			[::]
			/destroy mother
			Sid: She really came at the best part of the dream... Better hurry up.
		"	
}
