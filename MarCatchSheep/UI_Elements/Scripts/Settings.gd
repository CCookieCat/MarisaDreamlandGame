extends Control

onready var Keybinds_Scene = preload("res://MarCatchSheep/UI_Elements/Scenes/KeybindsMenu.tscn")
onready var music_player = $MusicTest
onready var sfx_player = $SFXTest
onready var fps_display = get_parent().get_node("FPS_Display")
var keybinds_menu

func _input(event):
	if event.is_action_pressed("pause") && keybinds_menu != null: ## esc-key
		keybinds_menu.get_child(0).visible = false
		keybinds_menu.get_child(1).visible = false

func _on_MusicSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear2db(value))

func _on_SFXSlider_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))

func _on_TestMusic_pressed():
	if music_player.playing:
		music_player.stop()
	else:
		music_player.play()

func _on_TestSFX_pressed():
	if sfx_player.playing:
		sfx_player.stop()
	else:
		sfx_player.play()

func _on_CheckButton_toggled(button_pressed):
	fps_display.visible = button_pressed
	Lists.toggle_fps(button_pressed)

func _on_FullscreenChecker_toggled(_button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen

func _on_KeybindBtn_pressed():
	if keybinds_menu != null:
		keybinds_menu.get_child(0).visible = true
		keybinds_menu.get_child(1).visible = true
	else:
		keybinds_menu = Keybinds_Scene.instance()
		self.add_child(keybinds_menu)
