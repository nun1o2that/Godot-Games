extends Control


var USERINPUTLINES


func _ready():
	USERINPUTLINES = $MiddleGUI/LineContainer


# activates every time ENTER KEY is pressed, game also needs to be in progress still
func _input(event):
	if event is InputEventKey:
		
		if event.pressed and event.keycode == KEY_ENTER and !USERINPUTLINES.GAMEFINISHED:
			var counter = 0
			var correctWord = false
			
			# tried doing this without the loop and instead using ACTIVELINE variable, bitch was NULL tho
			
			while counter < USERINPUTLINES.userWordArray.size():
				correctWord = USERINPUTLINES.userWordArray[counter] == USERINPUTLINES.GAMEWORD
				if correctWord:
					USERINPUTLINES.gameWON()
				elif counter == 5 && !correctWord:
					USERINPUTLINES.gameLOST()
				counter += 1
				
		elif event.pressed and event.keycode == KEY_ESCAPE:
				get_tree().quit()
			
		# lets the user reset the game
		elif event.pressed and event.keycode == KEY_0:
			USERINPUTLINES.gameRESET()
			USERINPUTLINES.gameINITIALIZE()
			$MiddleGUI.gameword = USERINPUTLINES.GAMEWORD
			$MiddleGUI.resetKeyboardColors()


func _on_info_button_pressed():
	$InfoMenu.popup_centered()
