extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$"Farm/Farm Area 1".grab_focus()




# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):




func _on_Farm_Area_1_pressed():
	get_tree().change_scene("res://FarmArea1.tscn")
