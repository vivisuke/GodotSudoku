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
const NUM_OFFSET = 9*2

var cur_numButton = 1
var badNumCount = 0
var nButtonCmplt = 0	# 9個使用した数字ボタン数
var usedNums = []	# 1～9 の数字を何個使用しているか
var numButtons = []
var fallingNumber = load("res://fallingNumber.tscn")

func _ready():
	$TitleLabel.text = "Quest #%d" % Global.qNumber
	numButtons.resize(9)
	for i in range(9):
		numButtons[i] = numButtonNode(i+1)
	var name = "MarginContainer/VBoxContainer/HBoxContainer1/numButton1"
	var btn = get_node(name)
	$numButtonCursor.rect_position = btn.rect_global_position
	set_quest(Global.quest[Global.qNumber-1])
	#set_quest("008010240090320061102805007039452700 670103092 001679380 900706108 780091020 015030600")
	update_cell_cursor()
	$AudioBegin.play()
	pass # Replace with function body.
func is_clue_cell(x, y):
	var n = $CenterContainer/numTileMap.get_cell(x, y) 
	return n >= 0 && n < NUM_OFFSET
func get_cell_number(x, y):	# 0 for EMPTY, or [1, 9]
	var v = $CenterContainer/numTileMap.get_cell(x, y)
	return 0 if v < 0 else (v % 9) + 1
func set_cell_clue(x, y, n):
	$CenterContainer/numTileMap.set_cell(x, y, n-1)
func set_cell_number(x, y, n):		# n: [1, 9], 0 for clear
	if n<=0:
		$CenterContainer/numTileMap.set_cell(x, y, -1)
	else:
		$CenterContainer/numTileMap.set_cell(x, y, n-1+NUM_OFFSET)
func set_quest(q):
	usedNums.resize(9)
	for i in range(9):
		usedNums[i] = 0
	var ix = 0
	for ch in q:
		if ch != ' ':	# 空白は無視
			if ch < '1' || ch > '9':
				ch = '0'
			var n = ch as int
			#print(n)
			if n >= 1 && n <= 9:
				usedNums[n-1] += 1
			set_cell_clue(ix%9, ix/9, n)
			ix += 1
func show_cell_cursor(x, y, b):
	$CenterContainer/cursorTileMap.set_cell(x, y, 0 if b else -1)
func update_cell_cursor():
	for y in range(9):
		for x in range(9):
			var cn = get_cell_number(x, y)
			show_cell_cursor(x, y, cur_numButton == cn)
			#if selected_num == 0 || selected_num != cn:
			#	$cursorTileMap.set_cell(x, y, -1)	# カーソル非表示
			#else:
			#	$cursorTileMap.set_cell(x, y, 0)	# カーソル表示
func is_solved():
	if badNumCount != 0:
		return false;
	for i in range(9):
		if usedNums[i] != 9:
			return false;
	return true;
func is_OK(x, y, n):	# 入れた数字に重複が無いかどうかチェック
	for i in range(9):
		if i != x && get_cell_number(i, y) == n:
			return false
		if i != y && get_cell_number(x, i) == n:
			return false
		var x0 = x - x % 3
		var y0 = y - y % 3
		for v in range(3):
			for h in range(3):
				if x != x0 + h && y != y0 + v && get_cell_number(x0+h, y0+v) == n:
					return false
	return true
func check_cell_numbers():
	badNumCount = 0
	for y in range(9):
		for x in range(9):
			var n = get_cell_number(x, y)
			if n != 0:
				if !is_OK(x, y, n):
					badNumCount += 1
					n += 9
				if !is_clue_cell(x, y):
					set_cell_number(x, y, n)
				else:
					set_cell_clue(x, y, n)
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
		#var v = $CenterContainer/numTileMap.get_cell(x, y)
		#print("v = ", v)
		#$CenterContainer/numTileMap.set_cell(x, y, v+1)
		var n = get_cell_number(x, y)
		if is_clue_cell(x,y):
			cur_numButton = n
			updateNumButtonCursor()
			update_cell_cursor()
			pass
		else:
			if n == cur_numButton:
				set_cell_number(x, y, 0)
				usedNums[cur_numButton-1] -= 1
				var ns = fallingNumber.instance()
				ns.setup(n)
				add_child(ns)
				ns.position = Vector2(BOARD_ORG_X+CELL_WD*(x+0.5), BOARD_ORG_Y+CELL_WD*(y+0.5))
			else:
				if n != 0:
					usedNums[n-1] -= 1
					var ns = fallingNumber.instance()
					ns.setup(n)
					add_child(ns)
					ns.position = Vector2(BOARD_ORG_X+CELL_WD*(x+0.5), BOARD_ORG_Y+CELL_WD*(y+0.5))
				set_cell_number(x, y, cur_numButton)
				usedNums[cur_numButton-1] += 1
			#set_cell_number(x, y, 0 if n == cur_numButton else cur_numButton)
			check_cell_numbers()
			update_cell_cursor()
			#print(usedNums)
			var nbc = nButtonCmplt
			nButtonCmplt = 0
			for i in range(9):
				var b : bool = usedNums[i] == 9
				if b:
					nButtonCmplt += 1
				numButtons[i].set_disabled(b)
			if nButtonCmplt > nbc:
				$AudioNumCmplt.play()
			else:
				$AudioNumButton.play()
			if is_solved():
				print("solved")
				$AudioSolved.play()
				$AcceptDialog.window_title = "Congratulations !"
				$AcceptDialog.dialog_text = "Good Job !, you are great."
				$AcceptDialog.popup_centered()
	pass
func _input(event):
	if event is InputEventMouseButton and event.pressed:
		var xy = posToXY(event.position)
		print(xy)
		if xy.x >= 0:
			cell_pressed(xy.x, xy.y)
	pass
func numButtonNode(num):
	var hbc = (num - 1) / 3 + 1
	var name = str("MarginContainer/VBoxContainer/HBoxContainer", hbc, "/numButton", num)
	#print(name)
	return get_node(name)
func updateNumButtonCursor():
	var btn = numButtonNode(cur_numButton)
	#print(btn.rect_global_position)
	$numButtonCursor.rect_position = btn.rect_global_position
func numButton_pressed(num):	# 数字ボタン押下処理
	cur_numButton = num			# 現数字ボタン
	updateNumButtonCursor()		# 数字ボタンカーソル更新
	#print("num ", num, " pressed")
	update_cell_cursor()		# セルカーソル更新
	$AudioNumButton.play()		# 効果音
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

func _on_backButton_pressed():
	get_tree().change_scene("res://LevelScene.tscn")
