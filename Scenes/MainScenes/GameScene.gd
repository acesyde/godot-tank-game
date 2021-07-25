extends Node2D

onready var ui: UI = $"UI"

var map_node: Node2D

var build_mode: bool = false
var build_valid: bool = false
var build_location
var build_type: String

func _ready() -> void:
	map_node = get_node("Map1")
	
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.connect("pressed", self, "initiate_build_mode", [i.get_name()])

func _process(delta: float) -> void:
	if build_mode:
		update_tower_preview()
		
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel") and build_mode:
		cancel_build_mode()
		
	if event.is_action_released("ui_accept") and build_mode:
		verify_and_build()
		cancel_build_mode()

func initiate_build_mode(tower_type: String) -> void:
	build_type = tower_type + "T1"
	build_mode = true
	ui.set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview() -> void:
	var tower_exclusion_node: Node = map_node.get_node("TowerExclusion")
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_tile: Vector2 = tower_exclusion_node.world_to_map(mouse_position)
	var tile_position: Vector2 = tower_exclusion_node.map_to_world(current_tile)
	
	if tower_exclusion_node.get_cellv(current_tile) == -1:
		ui.update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
	else:
		ui.update_tower_preview(tile_position, "adff4545")
		build_valid = false
	
func cancel_build_mode() -> void:
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").queue_free()
	
func verify_and_build():
	if build_valid:
		var new_tower = load("res://Scenes/Turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		map_node.get_node("Turrets").add_child(new_tower, true)
