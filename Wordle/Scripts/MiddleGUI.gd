extends Control

# variable can only be gotten with the @onready thing
@onready var gameword = $LineContainer.GAMEWORD
var lineword


func _input(event):
	
	var letterlabel
	lineword = $LineContainer.lineWord
	
	if event is InputEventKey and $LineContainer.wordList.has(lineword):
		if event.pressed and !event.is_echo() and event.keycode == KEY_ENTER:
		
			# outer loop through the three lines
			for line in $Keyboard/VBoxContainer.get_child_count():
				
				# inner loop through letters of each line
				for letter in $Keyboard/VBoxContainer.get_child(line).get_child_count():
					letterlabel = $Keyboard/VBoxContainer.get_child(line).get_child(letter)
					
					# if the user entered word doesnt have matching letters with gameword AND if letter hasnt alr been set to gray
					if !gameword.contains(letterlabel.text) && lineword.contains(letterlabel.text) && letterlabel.theme != letterlabel.colorArray[1]:
						letterlabel.changeLabelTheme(1)
					
					# letter is found or in correct position
					elif gameword.contains(letterlabel.text) && lineword.contains(letterlabel.text):
						for n in 5:
							# if the keyboard letter, user-entered-word letter and letter of gameword are all the same AND letter isnt already green
							if gameword[n] == letterlabel.text && lineword[n] == letterlabel.text && letterlabel.theme != letterlabel.colorArray[3]:
								letterlabel.changeLabelTheme(3)
							# letter isnt at right position in GAMEWORD, but at the user entered word; ONLY SET TO YELLOW IF IT ISN'T ALREADY GREEN!!!
							elif gameword[n] != letterlabel.text && lineword[n] == letterlabel.text && letterlabel.theme != letterlabel.colorArray[3] && letterlabel.theme != letterlabel.colorArray[2]:
								letterlabel.changeLabelTheme(2)


# called in MAIN.gd when the game is reset
# sets all letters back to the default theme
func resetKeyboardColors():
	var letterlabel
	
	# outer loop through the three lines
	for line in $Keyboard/VBoxContainer.get_child_count():
			# inner loop through letters of each line
			for letter in $Keyboard/VBoxContainer.get_child(line).get_child_count():
				letterlabel = $Keyboard/VBoxContainer.get_child(line).get_child(letter)
				letterlabel.changeLabelTheme(0)

