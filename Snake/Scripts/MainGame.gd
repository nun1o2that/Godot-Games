extends Node


const SNAKE = 0 # SnakeSpriteSheet has ID 0 in the SnakeAndApple TileMap
const APPLE = 1 # AppleSprite has ID 1 in the SnakeAndApple TileMap
const INITIALPOSITION = [Vector2i(16, 16), Vector2i(17, 16)]
const INITIALDIRECTION = Vector2i(1, 0)
var JADEBACKGROUND # cant use constants for these two apparently but its ok
var TILEBACKGROUND
var snakeBody
var snakeDirection
var applePosition # gets randomly generated using function
var appleEaten
var gameOver


# done once when the scene is ready
func _ready():
	# initializing these once in here, dont need to do them in resetGame()
	JADEBACKGROUND = $OneBadGloopAndSheDoWhatIYoinky
	TILEBACKGROUND = $BackgroundTiles
	resetGame()
	

# yada yada
func moveSnake():
	var bodyCopy
	var newHead
	
	# one position gets added to the snake
	if appleEaten:
		bodyCopy = snakeBody.slice(0, snakeBody.size())
		$Score.updateScore()
	# snake retains its size
	else:
		deleteTiles(SNAKE)
		# create a copy of the snake that's missing the head (- 2 instead of - 1
		bodyCopy = snakeBody.slice(0, snakeBody.size() - 1)
	newHead = bodyCopy[0] + snakeDirection
	bodyCopy.insert(0, newHead)
	snakeBody = bodyCopy
	

# set all tiles where the snake is to -1 (no sprite)
func deleteTiles(ID):
	var cells = $SnakeAndApple.get_used_cells_by_id(ID)
	# every member of the cells array is already a Vector2i
	# meaning i can simply loop through them and set them without using a temp var
	for coordOfCell in cells:
		$SnakeAndApple.set_cell(0, coordOfCell, -1)


# goes through the array of the snake and places sprites accordingly
func drawSnake():
	var cell
	var sprite
	
	for n in snakeBody.size():
		cell = snakeBody[n]
		
		# setting the head
		if n == 0:
			sprite = relationTail(snakeBody[0], snakeBody[1], 0)	
		
		# setting the tail
		elif n == (snakeBody.size() - 1):
			sprite = relationTail(snakeBody[n], snakeBody[n - 1], 1)
		
		# setting everything inbetween
		else:
			var previousBlock = snakeBody[n + 1] - cell
			var nextBlock = snakeBody[n - 1] - cell
			
			# bottom left corner
			if (previousBlock.x == 1 && nextBlock.y == -1) || (previousBlock.y == -1 && nextBlock.x == 1):
				sprite = Vector2i(3, 2)
			# bottom right corner
			elif (previousBlock.x == -1 && nextBlock.y == -1) || (previousBlock.y == -1 && nextBlock.x == -1):
				sprite = Vector2i(2, 2)
			# top left corner
			elif (previousBlock.x == 1 && nextBlock.y == 1) || (previousBlock.y == 1 && nextBlock.x == 1):
				sprite = Vector2i(1, 2)
			# to right corner
			elif (previousBlock.x == -1 && nextBlock.y == 1) || (previousBlock.y == 1 && nextBlock.x == -1):
				sprite = Vector2i(0, 2)
			# horizontal or vertical
			else:
				sprite = Vector2i(4, 2)
		$SnakeAndApple.set_cell(0, cell, SNAKE, sprite)


# calculates the relation between two cells (the tail and the one before)
# returns a specific sprite position based on the result
func relationTail(firstCell, secondCell, type):
	var blockDifference = secondCell - firstCell
	if blockDifference == Vector2i(0, -1): return Vector2i(0, type) # UP
	elif blockDifference == Vector2i(1, 0): return Vector2i(3, type) # RIGHT
	elif blockDifference == Vector2i(0, 1): return Vector2i(2, type) # DOWN
	elif blockDifference == Vector2i(-1, 0): return Vector2i(1, type) # LEFT


# generates a new position for the apple and checks if it's valid
# (= doesn't cross over with the snake)
func generateApplePosition():
	randomize() # so we don't get the same random numbers every time?
	var x
	var y
	var applePos 
	var snakePos
	var valid = false
	
	while valid == false:
		x = randi() % 32
		y = randi() % 32
		applePos = Vector2i(x, y)
		snakePos = $SnakeAndApple.get_used_cells_by_id(0)
		for n in snakePos:
			if n == applePos:
				valid = false
				break
			else:
				valid = true
	return applePos


# applePosition calculated in generateApplePosition()
func drawApple():
	# layer 0, randomly generated position of apple, tilesheet apple, tile index
	$SnakeAndApple.set_cell(0, applePosition, APPLE, Vector2i(0, 0))


# if the position of the current apple corresponds with the head of the snake:
# generate a new apple position
# set apple eaten to true
func checkAppleEaten():
	if (applePosition == snakeBody[0]):
		applePosition = generateApplePosition()
		appleEaten = true
	else:
		appleEaten = false


# gets checked every frame of the game
# checks if either the snake has left the screen, or if it ate itself
func checkGameOver():
	var head = snakeBody[0]
	
	# snake leaves screen
	if head.x > 31 || head.x < 0 || head.y > 31 || head.y < 0:
		# print("snake left screen at " + str(head.x) + " " + str(head.y))
		gameOver = true
	
	# snake bites its own tail
	for n in snakeBody.slice(1, snakeBody.size() - 1):
		if (n == head):
			# print("snake ate itself")
			gameOver = true


# this function is called once at the start of the game
# as well as every time the "Reset Game" button in the pausemenu is clicked
func resetGame():
	gameOver = false
	appleEaten = false
	
	# when the game over screen isnt open, use the BLUE TILES
	TILEBACKGROUND.tileRow = 0
	TILEBACKGROUND.drawBG()
	
	# DO NOT CHANGE THIS FUCKIN ORDER IT WILL FUCK EFVERYTHING UP!!!!
	snakeBody = INITIALPOSITION
	snakeDirection = INITIALDIRECTION
	moveSnake()
	drawSnake()
	
	applePosition = generateApplePosition()
	drawApple()
	
	# once in the game over screen, this label on the top of the screen is invisible
	# on a reset (/start) of the game it gets set as visible again
	$Score.visible = true
	$Score.resetScore()
	$Score.updateScore()
	

# function only called when the gameOver variable is set to TRUE
func gameOverCall():
	# apparently also deletes the apple sprite? sure lol
	deleteTiles(0) 
	# when the game over screen is open, use the RED TILES
	TILEBACKGROUND.tileRow = 1
	TILEBACKGROUND.drawBG()
	$Score.visible = false # the score counter is shown in a label of the GameOverMenu instead
	$GameOverMenu.visible = true
	$GameOverMenu/ColorRect/VBoxContainer/ScoreLabel.text = "Score: " + str($Score.scoreCount)


# checks for inputs
func _input(event):
	const UP = Vector2i(0, -1)
	const RIGHT = Vector2i(1, 0)
	const DOWN = Vector2i(0, 1)
	const LEFT = Vector2i(-1, 0)
	
	# MOVEMENT
	if event.is_action_pressed("ui_up"): 
		if snakeDirection != DOWN:
			snakeDirection = UP
	elif event.is_action_pressed("ui_right"):
		if snakeDirection != LEFT:
			snakeDirection = RIGHT 
	elif event.is_action_pressed("ui_down"):
		if snakeDirection != UP:
			snakeDirection = DOWN
	elif event.is_action_pressed("ui_left"):
		if snakeDirection != RIGHT:
			snakeDirection = LEFT
			
	# MENUS
	elif event.is_action_pressed("ui_cancel") && !$GameOverMenu.visible:
		$PauseMenu.visible = true
	elif $PauseMenu/ColorRect/VBoxContainer/ResetButton.button_pressed || $GameOverMenu/ColorRect/VBoxContainer/ResetButton.button_pressed:
		resetGame()
	elif $PauseMenu/ColorRect/VBoxContainer/NormalBG.button_pressed:
		TILEBACKGROUND.visible = true
		JADEBACKGROUND.visible = false
		$Score.set("theme_override_colors/font_color", Color.WHITE)
	elif $PauseMenu/ColorRect/VBoxContainer/AWESOMEBG.button_pressed:
		TILEBACKGROUND.visible = false
		JADEBACKGROUND.visible = true
		$Score.set("theme_override_colors/font_color", Color.BLACK)
		

# inserted from SnakeTick -> Nodes (next to Inspector on the right)
# every time the timer counts up these things get done
func _on_snake_tick_timeout():
	if !$PauseMenu.visible && !$GameOverMenu.visible && !gameOver:
		moveSnake()
		drawSnake()
		checkAppleEaten()
	

# checked every frame of the game (?)
# apple drawn here bc it looks better lol
func _process(_delta):
	if !$PauseMenu.visible && !$GameOverMenu.visible:
		checkGameOver()
		drawApple()
		if gameOver:
			gameOverCall()
