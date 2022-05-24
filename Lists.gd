extends Node

var highest_combo = 0
var bombs_collected = 0
var lives_collected = 0

#GLOBAL SETTINGS:
var show_fps = true

func toggle_fps(value):
	show_fps = value

func reset_score():
	highest_combo = 0
	bombs_collected = 0
	lives_collected = 0
