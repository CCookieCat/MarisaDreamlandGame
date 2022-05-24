extends Node

signal spawn_note_block(midi)
signal notes_extracted(all_notes)

var viewport_width

var timer_accuracy = 0.1 # timer-T.o.
var notes = {}
var midi_key_spawns = {}
var midi_key_array = []

func _ready():
	if !midi_key_array.empty():
		midi_key_array.clear()
	if !midi_key_spawns.empty():
		midi_key_spawns.clear()
	if !notes.empty():
		notes.clear()
	print(str(midi_key_array) + str(midi_key_spawns) + str(notes))
	self.connect("spawn_note_block", get_tree().get_root().get_node("Main") , "_on_NoteVisualizer_note_passed")
	self.connect("notes_extracted", get_tree().get_root().get_node("Main") , "_on_NoteVisualizer_notes_extracted")
	$Audio.connect("finished", get_tree().get_root().get_node("Main") , "_on_Audio_finished")
	# read json file:
	var file = File.new()
	file.open("res://MarCatchSheep/SFX/Love-Colored-Notes.txt", file.READ)
	var all_notes = JSON.parse(file.get_as_text()).result
	file.close()
	# write dictionary:
	for note in all_notes:
		var time = str(stepify(note["time"], timer_accuracy))
		#write timing-dict: -- time-played = key , duration
		notes[time] = [ note["midi"], note["duration"] ]
		#write key-array:
		var midi_key = note["midi"]
		if midi_key > 75: #low notes as bombs or lucky sheep - NO FIXED SPAWN POSITION
			if !midi_key_array.has(midi_key):
				midi_key_array.append(midi_key)
	
	emit_signal("notes_extracted", midi_key_array) # To main scene

func _play_audio():
	$NoteTimer.start(timer_accuracy) #IMPORTANT, DON'T FORGET(WAIT TIME!)!!
	if notes.has("0"):
		$Audio.play()

func _on_NoteTimer_timeout():
	var song_time = str(stepify($Audio.get_playback_position(), timer_accuracy))
	
	if notes.has(song_time):
		print("Note" + str(notes[song_time]))
		## TESTING:
		emit_signal("spawn_note_block", notes[song_time][0]) #get index0 midi-key
