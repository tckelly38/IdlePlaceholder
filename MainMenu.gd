extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	$"Farm/Farm Area 1".grab_focus()

func _on_Farm_Area_1_pressed():
	get_tree().change_scene("res://FarmArea1.tscn")
