extends Resource
class_name LootItem

export(String) var item_name
export(int) var cost_in_tries
export(float) var risk
export(float) var drop_chance
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init(p_item_name = "", p_cost_in_tries = 0, p_risk = 0.0, p_drop_chance = 0.0):
	item_name = p_item_name
	cost_in_tries = p_cost_in_tries
	risk = p_risk
	drop_chance = p_drop_chance
	
