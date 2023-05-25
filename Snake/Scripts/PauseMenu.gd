extends Control


# done once when the scene is ready
func _ready():
	visible = false	# pause menu is not seen


# when the resume button is pressed, set the menu invisible again
func _on_resume_button_pressed():
	visible = false


# signal is here, actual commands are in MainGame.gd
# resets the game and then goes invisible again
func _on_reset_button_pressed():
	visible = false


# when the quit button is pressed, exit the game
func _on_quit_button_pressed():
	get_tree().quit()


func _on_normal_bg_pressed():
	pass # Replace with function body.


func _on_awesomebg_pressed():
	pass # Replace with function body.
