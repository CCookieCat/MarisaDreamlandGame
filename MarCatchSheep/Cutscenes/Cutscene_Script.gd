extends Control

var main_loaded_scene

func _input(event):
	if event.is_action_pressed("pause"):
		_change_scene()

func _ready():
	main_loaded_scene = ResourceLoader.load("res://MarCatchSheep/Scenes/Main_Game_Scene_MCS.tscn")
	$AnimationPlayer.play("IntroScene")

func _change_scene():
	if get_tree().change_scene_to(main_loaded_scene) != OK:
		print ("Error changing scene to Game")
