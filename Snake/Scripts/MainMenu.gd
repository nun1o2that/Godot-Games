extends Control


# when the start button is pressed, go to the main scene
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/MainGame.tscn")

	
# when the quit button is pressed, exit the game
func _on_quit_button_pressed():
	get_tree().quit()
