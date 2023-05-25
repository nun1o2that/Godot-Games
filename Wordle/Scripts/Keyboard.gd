extends Control


# alphabet divided into 3 lines for easier assigning
var line0Letters
var line1Letters
var line2Letters


# called once when keyboard is initialized
# sets the letters to each key
func _ready():
	line0Letters = "QWERTYUIOP" # just like new york timez
	line1Letters = "ASDFGHJKL"
	line2Letters = "ZXCVBNM"
	
	var alphabet	# reassigned on every line and looped through to set to the letters
	var letterlabel # current label
	
	# outer loop through the three lines
	for line in $VBoxContainer.get_child_count(): 
		match(line):
			0: alphabet = line0Letters 
			1: alphabet = line1Letters
			2: alphabet = line2Letters
		# inner loop through letters of each line
		for letter in $VBoxContainer.get_child(line).get_child_count():
			letterlabel = $VBoxContainer.get_child(line).get_child(letter)
			letterlabel.text = alphabet.substr(letter, 1) # literally just String.charAt()
