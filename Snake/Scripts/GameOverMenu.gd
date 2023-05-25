extends Control


# done once when the scene is ready
func _ready():
	visible = false	# pause menu is not seen


# when the reset button is pressed, go back to the main scene
# this resets the game automatically
func _on_reset_button_pressed():
	visible = false


# when the quit button is pressed, exit the game
func _on_quit_button_pressed():
	get_tree().quit()
