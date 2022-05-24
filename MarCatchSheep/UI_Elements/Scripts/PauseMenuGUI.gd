extends CanvasLayer

func _ready():
	get_child(0).visible = false
	get_child(1).visible = false
	get_child(2).visible = false
	pause_mode = Node.PAUSE_MODE_PROCESS

func _input(event):
	if event.is_action_pressed("pause"):
		$GridContainer/VBoxContainer/Resume.grab_focus()
		_pause_and_hide_menu()
	if Input.is_key_pressed(KEY_P):
		toggle_screenshot_mode()

func toggle_screenshot_mode():
	$ScreenshotModeDisplay.text = str("Screenshot Mode: " + str(get_child(0).visible))
	get_child(0).visible = !get_child(0).visible
	get_child(1).visible = !get_child(1).visible

func _on_Resume_pressed():
	_pause_and_hide_menu()

func _pause_and_hide_menu():
	get_tree().paused = !get_tree().paused
	get_child(0).visible = get_tree().paused
	get_child(1).visible = get_tree().paused
	get_child(2).visible = get_tree().paused

func _on_Return_pressed():
	_pause_and_hide_menu()
	if get_tree().change_scene("res://MarCatchSheep/UI_Elements/Scenes/Menu.tscn") != OK:
		print ("Error changing scene to Menu Scene")

func _on_Quit_pressed():
	_pause_and_hide_menu()
	if get_tree().reload_current_scene() != OK:
		print ("Error reloading Game Scene")
