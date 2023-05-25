extends Node2D


var tileRow


# done once when the scene is ready
func _ready():
	tileRow = 0
	drawBG()


# called everytime the tileRow gets updated (i think lol)
func drawBG():
	var coordOfCell
	var tileIndex
	
	# print the playing board with a chess pattern
	# simple loops to go through the columns (inner loop), then move to the next row (outer loop), and so on
	for o in 32:
		for i in 32:
			coordOfCell = Vector2i(i, o)
			if i % 2 == 0 && o % 2 == 0 || i % 2 == 1 && o % 2 == 1:
				tileIndex = Vector2i(0, tileRow) # first pos
			else:
				tileIndex = Vector2i(1, tileRow) # second pos
			# layer 0, current coordinate, FloorSpriteSheet (ID 0 in BG TileMap), tile specified in loop
			$BG.set_cell(0, coordOfCell, 0, tileIndex)
