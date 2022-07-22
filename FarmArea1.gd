extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"




# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	$enemy/Sprite.visible = false
	var t = rand_range(1, $enemy.spawnRate)
	yield(get_tree().create_timer(t), "timeout")
	$enemy/Sprite.visible = true
	$enemy/AnimationPlayer.play("idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Back_pressed():
	get_tree().change_scene("res://MainMenu.tscn")



func _process(delta):
	pass

