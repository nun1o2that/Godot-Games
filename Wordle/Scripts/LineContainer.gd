extends VBoxContainer


var ACTIVELINE			# used to progress from one line to the next
var lineWord			# words of individual lines
var userWordArray	 	# saves all words user enters in this script, used in MAIN.gd 2 determine gameover
var GAMEFINISHED		
var GAMEWORD
var wordList = []


# Called when the node enters the scene tree for the first time.
# only the worldList needs to be loaded here, only once per executable open.
func _ready():
	var txtFile = FileAccess.open("res://WordLists/FINALLIST.txt", FileAccess.READ)
	while txtFile.get_position() < txtFile.get_length():
		wordList.push_back(txtFile.get_line().to_upper())
	gameINITIALIZE()


# handles initializing the rest of the values
# called once at the executable open, then on subsequent game loops if user chooses 2 play again
func gameINITIALIZE():
	ACTIVELINE = 0 		# place the user on the top line again
	lineWord = ""
	userWordArray = []	# reset this array cuz i think it stays otherwise lol
	
	GAMEFINISHED = false
	get_child(ACTIVELINE).lineActive = true	# in order for user to edit it
	
	randomize() # so the word's different each time?
	# wordList loaded once in _ready(), can just be used now
	GAMEWORD = wordList.pick_random() # loaded once 
	
	for n in get_child_count() - 1:
		get_child(n).userInput = ""				# every line's userInput back to nothing
		get_child(n).changeAllLabelThemes(0)	# theme of every line's labels back to default
		await get_tree().create_timer(0.15).timeout # to obscure the text changing to nothing
		get_child(n).printLettersToLabel("")	# text of every line's labels back to empty string
	
	# for testing purposes
	print("THIS GAME'S WORD: " + GAMEWORD)


# called every time there's a keystroke
# narrowed down to the ENTER KEY here
# if word valid, it gets saved and user moves to next line
func _input(event):
	# entering a new line in the game using ENTER KEY, only possible after entering a whole word
	# line also needs to be ACTIVE = editable
	if event is InputEventKey and get_child(ACTIVELINE).lineActive:	
		
		if event.pressed and !event.is_echo() and event.keycode == KEY_ENTER:
			lineWord = get_child(ACTIVELINE).userInput
			
			# lineWord pushed into userWordArray for checking WIN/LOSS later
			# little label underneath grid gets changed as well
			if lineWord.length() < 5:
				$WordMessages.text = "Word must be 5 letters long!"
			elif lineWord.length() == 5 && wordList.has(lineWord):
				$WordMessages.text = " "
				userWordArray.push_back(lineWord)
				if !GAMEFINISHED:
					moveToNextLine()
			# lineWord NOT pushed into userWordArray
			elif !wordList.has(lineWord):
				$WordMessages.text = "Word does not exist in this game!"


# set the current line inactive, move to the next one and set that one to active
func moveToNextLine():
	get_child(ACTIVELINE).lineActive = false
	updateLineColors()
	
	if ACTIVELINE < 5:
		ACTIVELINE += 1
		get_child(ACTIVELINE).lineActive = true


# update individual label's colors according to wordle rules
# only called before moving to the next line in moveToNextLine()
func updateLineColors():
	var currentLine
	var currentLabel
	
	for x in 5: # every line has 5 labels = letters
		currentLine = get_child(ACTIVELINE)
		currentLabel = currentLine.get_child(x)
		
		# GAMEWORD has the letter of the currentLabel SOMEWHERE in it
		if GAMEWORD.contains(currentLabel.text):
			
			# currentLabel's letter and GAMEWORD's letters are both at the SAME STRING POSITION
			if GAMEWORD[x] == currentLabel.text:
				currentLabel.changeLabelTheme(3)	# green
				
			# letters NOT at the same position, but letter still contained in GAMEWORD
			else:
				currentLabel.changeLabelTheme(2)	# yellow
		
		# GAMEWORD does NOT have the letter of currentLabel anywhere in it
		else:
			currentLabel.changeLabelTheme(1)		# gray


# if either the right word has been found or the last line is reached:
# set all lineActive properties to false, so user can't continue typing 
func endValues():
	for n in get_child_count() - 1:
		get_child(n).lineActive = false


func gameRESET():
	$WordMessages.text = "Game reset!"
	GAMEFINISHED = true
	endValues()


# you are awesome and cool
func gameWON():
	await get_tree().create_timer(0.5).timeout # pops up with the spinny animation instead of b4
	$WordMessages.text = "You won! :D Press 0 to reset."


# learn more words idiot!!!!!!!!!!!!!!!
func gameLOST():
	await get_tree().create_timer(0.5).timeout # pops up with the spinny animation instead of b4
	$WordMessages.text = "You lost :( The word was " + GAMEWORD + ". Press 0 to reset."
