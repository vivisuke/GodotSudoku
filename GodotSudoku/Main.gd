extends Node2D

const SCREEN_WIDTH = 500
const SCREEN_HEIGHT = SCREEN_WIDTH * 1.6
const TTLBAR_HEIGHT = SCREEN_WIDTH * 0.1
const CELL_WD = 53
const CELL_HT = CELL_WD
const LR_MARGIN = (SCREEN_WIDTH - CELL_WD*9) / 2.0
const TOP_MARGIN = LR_MARGIN * 3
const BOARD_ORG_X = 11.5	# LR_MARGIN
const BOARD_ORG_Y = 81		# TTLBAR_HEIGHT + TOP_MARGIN
const BOARD_WIDTH = CELL_WD * 9
const BOARD_HEIGHT = BOARD_WIDTH

var cur_numButton = 1

func _ready():
	var name = "MarginContainer/VBoxContainer/HBoxContainer1/numButton1"
	var btn = get_node(name)
	$numButtonCursor.rect_position = btn.rect_global_position
	pass # Replace with function body.
func posToXY(pos):
	var xy = Vector2(-1, -1)
	if pos.x >= BOARD_ORG_X && pos.x < BOARD_ORG_X + BOARD_WIDTH:
		if pos.y >= BOARD_ORG_Y && pos.y < BOARD_ORG_Y + BOARD_HEIGHT:
			xy.x = floor((pos.x - BOARD_ORG_X) / CELL_WD)
			xy.y = floor((pos.y - BOARD_ORG_Y) / CELL_HT)
	return xy
func cell_pressed(x, y):	# 盤面セルがクリックされた場合
	print("x = ", x, ", y = ", y)
	if x>=0:
		#var v = $CenterContainer/cursorTileMap.get_cell(x, y)
		#print("v = ", v)
		#$CenterContainer/cursorTileMap.set_cell(x, y, -1 - v)
		var v = $CenterContainer/numTileMap.get_cell(x, y)
		#print("v = ", v)
		$CenterContainer/numTileMap.set_cell(x, y, v+1)
	pass
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var xy = posToXY(event.position)
		print(xy)
		if xy.x >= 0:
			cell_pressed(xy.x, xy.y)
	pass

func numButton_pressed(num):
	#print("num ", num, " pressed")
	var hbc = (num - 1) / 3 + 1
	var name = str("MarginContainer/VBoxContainer/HBoxContainer", hbc, "/numButton", num)
	#print(name)
	var btn = get_node(name)
	#print(btn.rect_global_position)
	$numButtonCursor.rect_position = btn.rect_global_position
	cur_numButton = num
func _on_numButton1_pressed():
	numButton_pressed(1)
func _on_numButton2_pressed():
	numButton_pressed(2)
func _on_numButton3_pressed():
	numButton_pressed(3)
func _on_numButton4_pressed():
	numButton_pressed(4)
func _on_numButton5_pressed():
	numButton_pressed(5)
func _on_numButton6_pressed():
	numButton_pressed(6)
func _on_numButton7_pressed():
	numButton_pressed(7)
func _on_numButton8_pressed():
	numButton_pressed(8)
func _on_numButton9_pressed():
	numButton_pressed(9)
