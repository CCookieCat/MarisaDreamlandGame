extends Control

onready var menu1 = $MainMenu
onready var menu2 = $SettingsMenu
onready var tween = $SlideTween

var menu_origin_pos = Vector2.ZERO
var menu_origin_size = Vector2.ZERO
var current_menu
var menu_stack = []
export var menu_transition_time = 0.5

func _ready():
	$MainMenu/CenterContainer/HBoxContainer/VBoxContainer/PlayBtn.grab_focus()
	menu_origin_size = get_viewport_rect().size
	current_menu = menu1

func move_next_menu(next_menu_id):
	var next_menu = get_menu_from_id(next_menu_id)
	tween.interpolate_property(current_menu, "rect_global_position", current_menu.rect_global_position, Vector2(-menu_origin_size.x, 0), menu_transition_time)
	tween.interpolate_property(next_menu, "rect_global_position", next_menu.rect_global_position, menu_origin_pos, menu_transition_time)
	#added:
	tween.interpolate_property(get_parent().get_child(0).get_node("BlurTop").get_material(), "shader_param/lod", 0.1, 2.0, menu_transition_time)
	tween.start()
	menu_stack.append(current_menu)
	current_menu = next_menu

func move_prev_menu():
	var previous_menu = menu_stack.pop_back()
	if previous_menu != null:
		tween.interpolate_property(previous_menu, "rect_global_position", previous_menu.rect_global_position, menu_origin_pos, menu_transition_time)
		tween.interpolate_property(current_menu, "rect_global_position", current_menu.rect_global_position,  Vector2(menu_origin_size.x, 0), menu_transition_time)
		# added:
		tween.interpolate_property(get_parent().get_child(0).get_node("BlurTop").get_material(), "shader_param/lod", 2.0, 0.1, menu_transition_time)
		tween.start()
		current_menu = previous_menu

func get_menu_from_id(menu_id):
	match menu_id:
		"menu1":
			return menu1
		"menu2":
			return menu2
		_:
			return menu1

# MAIN MENU
func _on_PlayBtn_pressed():
	if get_tree().change_scene("res://MarCatchSheep/Cutscenes/IntroScene.tscn") != OK:
		print ("Error changing scene to Game Scene")

func _on_SettingBtn_pressed():
	move_next_menu("menu2")

func _on_QuitBtn_pressed():
	get_tree().quit()

#SETTINGS MENU
func _on_returnBtn_pressed():
	move_prev_menu()
