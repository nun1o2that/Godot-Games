extends Label


# loading all the theme as variables so they can be switched to easily
var DEFAULT = load("res://Styles/Label_input.tres")	# 0
var GRAY = load("res://Styles/Label_gray.tres")		# 1
var YELLOW = load("res://Styles/Label_yellow.tres")	# 2
var GREEN = load("res://Styles/Label_green.tres")	# 3


# for easy access in LineContainer.gd using numbers 0 - 3
var colorArray = [DEFAULT, GRAY, YELLOW, GREEN]


# every label starts out with DEFAULT theme
func _ready():
	theme = colorArray[0]


# called from LineContainer.gd when moving from the current line to the next
# colors depend on the conditions met
# the timer makes it look nice yeha
func changeLabelTheme(color):
	$LetterAnimation.play("flip")
	await get_tree().create_timer(0.3).timeout # color change gets obscured by this timer
	theme = colorArray[color]
	$LetterAnimation.play("flipBack")
