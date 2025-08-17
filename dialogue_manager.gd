extends Node

var encounter_dialogue: Dictionary = {
	0: ["Thanks for playing my first game! I'm a big fan of RPGs, so I decided to try making one.",
		"It should be pretty straightforward if you've ever played an RPG before. Have fun!"],
	1: ["Nice job! I think there's some tougher enemies ahead, though, so get ready!"],
	3: ["Okay, I'm gonna level with you. I think I like it.\n[font_size=12](and I have no idea how to fix it)[/font_size]",
		"I think we might've stumbled into gold here.\nSo... we're officially leaning into it.",
		"It's not a bug, it's a... uh... a CURSE! The [wave]spooooky cuuurrrrse[/wave] of the Demon King!"],
	4: ["Woah, these next enemies are pretty scary.\nI think you might be closing in on the [outline_size=8][color=#990000]Demon King[/color][/outline_size]!"]
}
var encounter_dialogue_seen := {}

var turn_dialogue_during_replay: Dictionary = {
	1: {
		1: ["Huh? Did you do that? ...was that a bug?"],
		2: ["Okay, you definitely didn't do that...",
			"I'm gonna go look into it, just hang tight and hope you don't die, I guess?"]
	}
}
var turn_dialogue_during_replay_seen := {}

var turn_dialogue_post_replay: Dictionary = {
	1: {
		1: ["You have control again? Well, that's good I guess... not sure why that happened.",
			"Hopefully that was just a one-time thing, but I'll keep digging."]
	},
	2: {
		1: ["Ooohhh, okay, I get it now. It's just remembering everything you're doing and repeating it?",
			"Interesting... I'll see what I can do and you...\nyou just keep at it. You're doing great, champ."]
	}
}
var turn_dialogue_post_replay_seen := {}

var instruction_tutorial: Array[String] = [
	"Okay, I've got good news and bad news.\nThe bad news is... I still have no idea what's happening.",
	"The good news is, I've hacked together this command list\nso we can see what the game is doing."
]

var demon_king_oblivion_dialogue: Array[String] = [
	"OMG, I just had the coolest idea. You're gonna love this. Ahem...",
	"[DEEP VOICE] \"Nice commands you've got there.\nIt'd be a shame if something happened to them...\"",
	"[DEEP VOICE] [font_size=32][outline_size=8][color=#990000][wave]\"OBLIVION!!!\"[/wave][/color][/outline_size][/font_size]"
]
var demon_king_oblivion_dialogue_seen := false

var demon_king_post_oblivion_dialogue: Array[String] = [
	"[DEEP VOICE] \"Now, it's time for some pain.\"",
	"Haha, cool right? Okay good luck!"
]

var post_death_dialogue: Dictionary = {
	0: ["Alright, I admit, that was pretty rough to watch.\nBut look! I've added a way for you to edit your commands!",
		"Err, I mean... um, you've now learned a [b][color=#ffbf00]SPELL[/color][/b] to fight the [b][color=#aa22aa]CURSE[/color][/b] and... [color=#ffbf00]change your fate![/color]",
		"Now, uh, go forth, adventurer, and defeat the Demon King to break the curse! [font_size=12](man, I'm good)[/font_size]"],
	1: ["Ouch. Well, it's okay, at least you can rewrite history and try again.",
		"Wait, \"rewrite history\"...? Should it be a [i]time loop[/i]? Maybe it's a time loop."],
	2: ["Oof, still dying? Maybe the game's too hard...\nHm... I should fix that in a day 1 patch..."],
}

var post_death_title: Dictionary = {
	0: "YOU SUCCUMBED TO THE [wave][outline_size=16][color=#aa22aa]CURSE![/color][/outline_size][/wave]",
	2: "YOU SUCCUMBED TO THE [fgcolor=black]CURSE[/fgcolor] [wave][outline_size=16][color=#aa22aa]TIME LOOP![/color][/outline_size][/wave]"
}

var victory_dialogue = [
	"You've done it! All of the enemies have been defeated forever!",
	"...no, like, literally forever. I didn't have time to implement restarting the game.",
	"I'm sure you can figure something out yourself, though. Thanks for playing!"
]

var game_manager: GameManager = null
var ui_manager: UIManager = null

func play_encounter_dialogue(encounter_index: int) -> bool:
	if encounter_index in encounter_dialogue and encounter_index not in encounter_dialogue_seen:
		ui_manager.queue_messages(encounter_dialogue[encounter_index])
		encounter_dialogue_seen[encounter_index] = true
		return true
	return false

func play_turn_dialogue() -> bool:
	var encounter_index = Globals.save_state.current_encounter_index
	var current_instruction := Globals.game_manager.current_instruction_index
	var during_replay := current_instruction < Globals.game_manager.instructions.size()
	if during_replay:
		if encounter_index in turn_dialogue_during_replay:
			if current_instruction in turn_dialogue_during_replay[encounter_index]:
				var key = "%d:%d" % [encounter_index, current_instruction]
				if key not in turn_dialogue_during_replay_seen:
					turn_dialogue_during_replay_seen[key] = true
					ui_manager.queue_messages(turn_dialogue_during_replay[encounter_index][current_instruction])
					return true
	else:
		if encounter_index in turn_dialogue_post_replay:
			var new_instructions = Globals.save_state.new_instructions_this_encounter
			if new_instructions in turn_dialogue_post_replay[encounter_index]:
				var key = "%d:%d" % [encounter_index, new_instructions]
				if key not in turn_dialogue_post_replay_seen:
					turn_dialogue_post_replay_seen[key] = true
					ui_manager.queue_messages(turn_dialogue_post_replay[encounter_index][new_instructions])
					return true
	return false

func play_instruction_tutorial_dialogue():
	ui_manager.queue_messages(instruction_tutorial)

func play_demon_king_oblivion_dialogue():
	if demon_king_oblivion_dialogue_seen:
		ui_manager.queue_message(demon_king_oblivion_dialogue[2])
	else:
		demon_king_oblivion_dialogue_seen = true
		ui_manager.queue_messages(demon_king_oblivion_dialogue)

func play_demon_king_post_oblivion_dialogue():
	ui_manager.queue_messages(demon_king_post_oblivion_dialogue)

func play_post_death_dialogue() -> bool:
	if Globals.save_state.current_run_count in post_death_dialogue:
		ui_manager.queue_messages(post_death_dialogue[Globals.save_state.current_run_count])
		return true
	return false

func get_post_death_title():
	var title = post_death_title[0]
	for i in range(0, Globals.save_state.current_run_count + 1):
		if i in post_death_title:
			title = post_death_title[i]
	return title

func play_victory_dialogue():
	ui_manager.queue_messages(victory_dialogue)
