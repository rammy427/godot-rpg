class_name Enemy extends CharacterBody2D

@export var charname: String = 'Enemy 1'
@export var speed: float = 100.0
@export var max_health: int = 200
@export var attack: int = 40
@export var defense: int = 33
var health = max_health

var player: Node2D = null
var isChasingPlayer: bool = false
var isFighting: bool = false

func _ready() -> void:
	var parentName: String = get_parent().name
	isFighting = (parentName == 'battle')
	$AnimatedSprite2D.play('idle')

func _physics_process(_delta: float) -> void:
	if (isChasingPlayer):
		velocity = speed * (player.position - position).normalized()
	else:
		velocity = Vector2.ZERO
	
	move_and_slide()

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	isChasingPlayer = true
	$AnimatedSprite2D.play('walk')

func _on_detection_area_body_exited(_body: Node2D) -> void:
	player = null
	isChasingPlayer = false
	$AnimatedSprite2D.play('idle')

func _on_hitbox_body_entered(_body: Node2D) -> void:
	if player != null:
		get_tree().change_scene_to_file("res://scenes/battle.tscn")

func executeBattleAction(target: Player) -> void:
	var dmg = max(1, randi_range(attack, 2 * attack) - target.defense)
	target.health -= dmg
	print(charname, ' deals ', dmg, ' damage to ', target.charname)
