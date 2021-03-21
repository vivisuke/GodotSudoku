extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#print(Global.quest)
	$CenterContainer2/HBoxContainer1/questButton1.set_quest(Global.quest[0])
	$CenterContainer2/HBoxContainer1/questButton2.set_quest(Global.quest[1])
	$CenterContainer2/HBoxContainer1/questButton3.set_quest(Global.quest[2])
	$CenterContainer2/HBoxContainer1/questButton4.set_quest(Global.quest[3])
	$CenterContainer2/HBoxContainer1/questButton5.set_quest(Global.quest[4])
	pass # Replace with function body.

func _input(event):
	#if event is InputEventMouseButton and event.pressed:
	#	get_tree().change_scene("res://Main.tscn")
	pass

func to_main(n):
	Global.qNumber = n
	get_tree().change_scene("res://Main.tscn")
func _on_questButton1_pressed():
	to_main(1)
func _on_questButton2_pressed():
	to_main(2)
func _on_questButton3_pressed():
	to_main(3)
func _on_questButton4_pressed():
	to_main(4)
func _on_questButton5_pressed():
	to_main(5)
