@export var sceneDialogues = {
    "quest1": [
        "
            *sid stands at the entrance of the hall
            Sid: Look who's up here to have a little family time today.
            Father: It's not like I had a choice.
            Mother: Well technically you did. Just had to send the Christmas cards to mom and dad like I asked
            Mother: But you chose not to.
            Father: It was not intentional. I am sorry I forgot.
            Mother: You also don't get to go to your lab today.
            Father: Whaaat!?
            Mother: You heard me.
            Father: :(
            Father: Your mother is in a bad mood today kiddo. Better not do anything to ruin it anymore.
            Sid: (Huh, the demon dream kind of makes sense now doesn't it.)
            Sid: Hmmm. What's for lunch mom?
            Mother: --------
            Sid: OMG! Thank you mother!	
            Mother: Wash your hands and sit down.
            [::]
            /get player
            /set player lastDirection 0,1
            /set player position 230,518
            /get player.0
            /set player.0 disabled true
            /get mother
            /set mother position -10,-115
            /get mother.1
            /set mother.1 texture load(res://Assets/characters/mother_back.png)
            /get mother.0
            /set mother.0 disabled true
            *mother goes to bring food

            *sid comes back after washing hands
            Father: You know about the game I've been working on?
            Sid: ---?
            Father: Yes ---. It's almost done.
            Sid: Can I test it?
            Father: Not until it's done.
            Sid: Oh come on! What's the harm in playing an unfinished game? 
            Sid: Bugs? I don't mind them. In fact, I love finding them.
            Father: It's a lot more than that.
            Father: Plus, I don't have access to my lab today.
            Father: So either way, you won't be able to play it today.
            Sid: :/
            [::]
            /set player.0 disabled false
            /set player speed 70
            /set mother position -1,27
            /set mother.1 texture load(res://Assets/characters/mother_front.png)
            /set player position 230,460
            *mother comes back with food and family eats
            *after lunch dexter goes back to his room
        "
    ],
    # "father": [
    #     "
    #         Father: Honey! I Have some important work today.
    #         Mother: I already told you no lab for you today.
    #         Father: But-
    #         Mother: No buts.
    #     "
    # ],
    # "mother": [
    #     "
    #         Father: Honey! I Have some important work today.
    #         Mother: I already told you no lab for you today.
    #         Father: But-
    #         Mother: No buts.
    #     "
    # ]
}