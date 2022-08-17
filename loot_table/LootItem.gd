extends Resource
class_name LootItem

export(String) var item_name
export(int) var cost_in_tries
export(float) var risk
export(float) var drop_chance
export(String) var sprite_source
export(bool) var is_animated
export(int) var h_frames
export(int) var v_frames
export(int) var total_frames
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _init(p_item_name = "", p_cost_in_tries = 0, p_risk = 0.0, p_drop_chance = 0.0,\
		   p_sprite_source = "", p_is_animated = false, p_h_frames = 1, p_v_frames = 1):
	item_name = p_item_name
	cost_in_tries = p_cost_in_tries
	risk = p_risk
	drop_chance = p_drop_chance
	sprite_source = p_sprite_source
	is_animated = p_is_animated
	h_frames = p_h_frames
	v_frames = p_v_frames
	if h_frames and v_frames:
		total_frames = h_frames * v_frames
	
