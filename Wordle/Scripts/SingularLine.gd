extends HBoxContainer


var userInput = ""		# this string's characters are output in each label
var lineActive = false	# gets set in LienContainer.gd accordingly


# checks for keystrokes from the user
func _input(event):
	# NEED this syntax for the if statement
	# otherwise it wont do shit
	# and i need them keycodes boy
	# ONLY DONE IF lineActive !!! this gets set as false for every line if the game is over
	if event is InputEventKey and lineActive:
		# from 65 to 90 (including), the keycodes are all LETTER keys
		# echocheck prevents input when button is HELD (!event.is_echo()) -> only ONE input per keypress
		# if key is pressed, add its text to this lines word, then reprint every letter in every label
		if event.pressed and (event.keycode >= 65 and event.keycode <= 90) and !event.is_echo():
			if userInput.length() < 5:
				userInput += event.as_text_keycode()
			printLettersToLabel(userInput)		
			
		# if backspace is pressed, remove the last letter from this lines word
		# then reprint every letter in every label
		elif event.pressed and event.keycode == KEY_BACKSPACE:
			if userInput.length() > 0:
				userInput = userInput.substr(0, userInput.length() - 1)
				printLettersToLabel(userInput)
				

# gets called every time a letter is typed or deleted using backspace
# loop through all the labels and do shit
func printLettersToLabel(wordToSet):
	
	# remove the letters from all labels first
	for n in get_child_count():
		get_child(n).text = ""
		
	# set the new letters
	for n in wordToSet.length():
		get_child(n).text = wordToSet[n]
		

# written for use in LineContainer.gd for easier resetting of all label colors
func changeAllLabelThemes(color):
	for n in get_child_count():
		get_child(n).changeLabelTheme(color)
