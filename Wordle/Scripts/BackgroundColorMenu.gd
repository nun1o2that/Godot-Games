extends Control


var colorPicker


# Called when the node enters the scene tree for the first time.
func _ready():
	colorPicker = $ColorPickerButton.get_picker()
	colorPicker.connect("color_changed", _on_color_changed) # connecting signal to a function
	
# IMMEDIATE color-change to the ColorRect, so the background
func _on_color_changed(color):
	$ColorRect.color = color
