extends Node2D

onready var ui: UI = $"UI"

var map_node: Node2D

var build_mode: bool = false
var build_valid: bool = false
var build_tile: Vector2 = Vector2.ZERO
var build_location
var build_type: String

var current_wave: int = 0
var enemies_in_wave: int = 0

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

####################
## Wave functions ##
####################

func start_next_wave() -> void:
	var wave_data = retrieve_wave_data()
	yield(get_tree().create_timer(0.2), "timeout")
	spawn_enemies(wave_data)
	
func retrieve_wave_data() -> Array:
	var wave_data = [["BlueTank", 3.0], ["BlueTank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	
func spawn_enemies(wave_data: Array) -> void:
	for i in wave_data:
		var new_enemy = load("res://Scenes/Enemies/" + i[0] + ".tscn").instance()
		map_node.get_node("Path").add_child(new_enemy, true)
		yield(get_tree().create_timer(i[1]), "timeout")

########################
## Building functions ##
########################

func initiate_build_mode(tower_type: String) -> void:
	if build_mode:
		cancel_build_mode()
		
	build_type = tower_type + "T1"
	build_mode = true
	ui.set_tower_preview(build_type, get_global_mouse_position())
	
func update_tower_preview() -> void:
	var tower_exclusion_node: TileMap = map_node.get_node("TowerExclusion")
	var mouse_position: Vector2 = get_global_mouse_position()
	var current_tile: Vector2 = tower_exclusion_node.world_to_map(mouse_position)
	var tile_position: Vector2 = tower_exclusion_node.map_to_world(current_tile)
	
	if tower_exclusion_node.get_cellv(current_tile) == -1:
		ui.update_tower_preview(tile_position, "ad54ff3c")
		build_valid = true
		build_location = tile_position
		build_tile = current_tile
	else:
		ui.update_tower_preview(tile_position, "adff4545")
		build_valid = false
	
func cancel_build_mode() -> void:
	build_mode = false
	build_valid = false
	get_node("UI/TowerPreview").free()
	
func verify_and_build():
	if build_valid:
		var new_tower: Turrets = load("res://Scenes/Turrets/" + build_type + ".tscn").instance()
		new_tower.position = build_location
		new_tower.built = true
		map_node.get_node("Turrets").add_child(new_tower, true)
		map_node.get_node("TowerExclusion").set_cellv(build_tile, 5)
