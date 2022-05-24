extends Node2D

# Block Sprites:
onready var NormalBlock_Scene = preload("res://MarCatchSheep/Scenes/N_NoteBlock.tscn")
onready var Pause_Menu = preload("res://MarCatchSheep/UI_Elements/Scenes/PauseMenu.tscn")
onready var ScoringScene = preload("res://MarCatchSheep/Cutscenes/ScoringScene.tscn")
onready var CatchVFX_Scene = preload("res://MarCatchSheep/VFX/Catch_VFX.tscn")
onready var FuseScene = preload("res://MarCatchSheep/VFX/B_Fuse_VFX.tscn")
onready var StarScene = preload("res://MarCatchSheep/VFX/Star_sparkle_VFX.tscn")
onready var special_BlockMaterial = preload("res://MarCatchSheep/VFX/Rainbow_Gradiant_Material.tres")

var combo_counter = 0
var bomb_counter = 0
var life_counter = 0
var highest_combo = 0
var midi_key_spawns = {}

func _input(event):
	if event.is_action_released("ui_right") || event.is_action_released("ui_left"):
		if $Tutorial/ControlsDisplay.visible:
			$Background/AnimationPlayer.play("Fade_Tutorial_Btns")

func _start_game():
	$NoteVisualizer._play_audio()

func _ready():
	var pause_Menu = Pause_Menu.instance()
	self.add_child(pause_Menu)

func _on_NoteVisualizer_notes_extracted(midi_key_array):
	midi_key_array.sort()
	var avg_note_width = get_viewport_rect().size.x / (midi_key_array.size() + 1)
	var idx = 1
	for key in midi_key_array:
		var spawnPos = avg_note_width * idx
		midi_key_spawns[key] = spawnPos
		idx += 1
	print(midi_key_spawns)

func _on_NoteVisualizer_note_passed(note):
	var type = 0
	var spawnPos = midi_key_spawns.get(note)
	if spawnPos == null:
		type = (randi() % 2) + 1
		spawnPos = midi_key_spawns.get(get_rand_key(midi_key_spawns.keys()))
#		print( "Random_Position_used: "+ str(spawnPos))
	
	match type:
		0: #instance NORMAL
			instance_scene(NormalBlock_Scene, spawnPos, type)
		1: #instance GOLDEN
			var special = instance_scene(NormalBlock_Scene, spawnPos, type)
			special.set_special_material(special_BlockMaterial)
			instance_special_particles(special)
		2: #instance BOMB
			var bomb = instance_scene(NormalBlock_Scene, spawnPos, type)
			bomb.set_sprite("bomb")
			instance_b_particles(bomb)

func instance_scene(scene_to_instance, instance_pos, instance_type):
	var block_instance = scene_to_instance.instance()
	self.add_child(block_instance)
	block_instance.type = instance_type
	block_instance.global_position.x = instance_pos
	return block_instance

func instance_b_particles(block_instance):
	var b_fuse_particle = FuseScene.instance()
	block_instance.add_child(b_fuse_particle)

func instance_special_particles(block_instance):
	var sparke_effect = StarScene.instance()
	block_instance.add_child(sparke_effect)

func get_rand_key(keyList):
	var key = keyList[randi() % keyList.size()]
	return key

func _on_block_caught():
	instance_bomb_effect("flower")
	increase_score()

func _on_bonus_caught():
	life_counter += 1
	instance_bomb_effect("flower")
	$Background/AnimationPlayer.play("Bnuuy Hopping")
	increase_score(1)
	
func increase_score(bonus = 0):
	combo_counter += 1 + bonus
	$PlayerMCS/Combo_Display.text = str(combo_counter)
	_compare_combo_counter()

func _on_damage_player():
	bomb_counter += 1
	if life_counter > 1:
		life_counter -= 1
	instance_bomb_effect("bomb")
	$PlayerMCS._inflict_daze(combo_counter)

func _on_combo_reset(): # from N_NoteBlock
	print("RESET!")
	combo_counter = 0
	$PlayerMCS/Combo_Display.text = ""

func _compare_combo_counter():
	if combo_counter > highest_combo:
		highest_combo = combo_counter
	$UI_Elements/Combo_Tracker.text = "COMBO: " + str(highest_combo)

func _on_Audio_finished(): #from Visualizer
	_write_global_score()
	$Background/AnimationPlayer.play("FadeToBlack")
	
func _write_global_score():
	Lists.highest_combo = highest_combo
	Lists.bombs_collected = bomb_counter
	Lists.lives_collected = life_counter

func _change_scene_to_score():
	if get_tree().change_scene("res://MarCatchSheep/Cutscenes/ScoringScene.tscn") != OK:
		print ("Error changing scene to Game")


func instance_bomb_effect(type):
	var pop_effect = CatchVFX_Scene.instance()
	$PlayerMCS.add_child(pop_effect)
	match type:
		"sheep":
			pop_effect.global_position = $PlayerMCS/Position2D/RigidBody2D/CollisionShape2D.global_position
			pop_effect.animation = "FlowerPop"
		"bomb":
			pop_effect.global_position = $PlayerMCS/Position2D.global_position
			pop_effect.animation = "SmokeEffect"
	pop_effect.playing = true
