extends TextureButton

const CELL_WIDTH = 7
const CELL_SPC = 1
const BUTTON_WIDTH = CELL_WIDTH*9 + CELL_SPC*10

var down = false
var quest = "008010240 090320061 102805007 039452700 670103092 001679380 900706108 780091020 015030600"

func _ready():
	pass # Replace with function body.

func _draw():
	quest = quest.replace(" ", "")
	var col = Color("#f0f0f0") if !down else Color("#f0f080")
	draw_rect(Rect2(0, 0, BUTTON_WIDTH, BUTTON_WIDTH), col)
	for y in range(9):
		var py = y * (CELL_WIDTH+CELL_SPC) + CELL_SPC
		for x in range(9):
			if quest[y*9+x] >= "1" && quest[y*9+x] <= "9":
				var px = x * (CELL_WIDTH+CELL_SPC) + CELL_SPC
				draw_rect(Rect2(px, py, CELL_WIDTH, CELL_WIDTH), Color("#808080"))

func _on_questButton_button_down():
	down = true;
	update()
	
func _on_questButton_button_up():
	down = false;
	update()

func set_quest(q):
	quest = q
	update()
