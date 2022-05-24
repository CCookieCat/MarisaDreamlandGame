extends Button

export var action_name = ""
var old_key

var set_key = false

func _pressed():
	old_key = text
	text = ""
	set_key = true

func _input(event):
	if set_key:
		if event is InputEventKey:
			#remove old key
			var new_key = InputEventKey.new()
			new_key.scancode = OS.find_scancode_from_string(old_key)
			InputMap.action_erase_event(action_name, new_key)
			#set new key
			InputMap.action_add_event(action_name, event)
			text = OS.get_scancode_string(event.scancode)
			set_key = false
