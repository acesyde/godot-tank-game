class_name Turrets
extends Node2D

onready var turret: Sprite = $Turret
onready var range_collisionshape2d: CollisionShape2D = $Range/CollisionShape2D
onready var animation_player: AnimationPlayer = $AnimationPlayer

var enemy_array: Array = []
var built: bool = false
var enemy: Node2D
var type: String
var ready: bool = true
var category: String

func _ready() -> void:
	if built:
		range_collisionshape2d.get_shape().radius = 0.5 * GameData.tower_data[type]["range"]

func _physics_process(delta: float) -> void:
	if enemy_array.size() != 0 and built:
		select_enemy()
		if not animation_player.is_playing():
			turn()
		if ready:
			fire()
	else:
		enemy = null
	
func turn() -> void:
	turret.look_at(enemy.position)
	
func select_enemy() -> void:
	var enemy_progress_array: Array = []
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	enemy = enemy_array[enemy_index]

func fire() -> void:
	ready = false
	
	if category == "Projectile":
		fire_gun()
	elif category == "Missile":
		fire_missile()
	
	enemy.on_hit(GameData.tower_data[type]["damage"])
	yield(get_tree().create_timer(GameData.tower_data[type]["rof"]), "timeout")
	ready = true

func fire_gun() -> void:
	animation_player.play("Fire")
	
func fire_missile() -> void:
	pass

func _on_Range_body_entered(body: Node) -> void:
	enemy_array.append(body.get_parent())

func _on_Range_body_exited(body: Node) -> void:
	enemy_array.erase(body.get_parent())
