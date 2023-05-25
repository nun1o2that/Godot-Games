extends Label


var scoreCount = 0
var labelText = "Score: "


# done once when the scene is ready
func _ready():
	set_text(labelText + str(scoreCount))


# called when a reset button (pause / gameover menu) is pressed
func resetScore():
	scoreCount = -1
	# print("reset")


# every time the snake eats an apple, the score gets updated
func updateScore():
	scoreCount += 1
	set_text(labelText + str(scoreCount))
