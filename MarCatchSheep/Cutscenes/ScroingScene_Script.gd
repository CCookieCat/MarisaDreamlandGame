extends Control

var countedNumber = 0

func _ready():
	$CenterContainer/VBoxContainer/return.grab_focus()
	$Tween.interpolate_property(self, "countedNumber", 0, Lists.highest_combo, 3, Tween.TRANS_EXPO)
	$Tween.start()
	toggle_score_counter_sound()

func toggle_score_counter_sound():
	if $ScoreCounterSound.playing:
		$ScoreCounterSound.stop()
	else:
		$ScoreCounterSound.play()
	
func _process(_delta):
	$CenterContainer/VBoxContainer/GridContainer/PointsDisplay.text = str(int(countedNumber))

func score_player():
	#$CenterContainer/VBoxContainer/GridContainer/PointsDisplay.text = str(Lists.highest_combo)
	$CenterContainer/VBoxContainer/GridContainer/SpecialsDisplay.text = str(Lists.lives_collected)
	$CenterContainer/VBoxContainer/GridContainer/BombsDisplay.text = str(Lists.bombs_collected)

func _return_to_MainMenu():
	if get_tree().change_scene("res://MarCatchSheep/UI_Elements/Scenes/Menu.tscn") != OK:
		print ("Error changing scene to Menu Scene")


func _on_return_pressed():
	Lists.reset_score()
	_return_to_MainMenu()


func _on_Tween_tween_all_completed():
	toggle_score_counter_sound()
	score_player()
