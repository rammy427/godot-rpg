class_name Enemy extends CharacterBody2D

signal battle_action_completed

@export var charname: String = 'GreenAI Soldier'
@export var speed: float = 100.0
@export var max_health: int = 200
@export var attack: int = 40
@export var defense: int = 33
var health = max_health

var player: Node2D = null
var isChasingPlayer: bool = false
var isFighting: bool = false
var nAttacks: int = 3
var waitTime: float = 2.0
var curAttacks: int = 0
var curTime: float = 0.0

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

func executeBattleAction(target: Player, dt: float) -> void:
	if curAttacks < nAttacks:
		curTime += dt
		if curTime >= waitTime:
			attackTarget(target)
			curTime = 0
			curAttacks += 1
	else:
		battle_action_completed.emit()
	
func attackTarget(target: Player) -> void:
	var dmg = max(1, randi_range(attack, 2 * attack) - target.defense)
	target.health = max(0, target.health - dmg)
	print(charname, ' deals ', dmg, ' damage to ', target.charname)

func isDead() -> bool:
	return health <= 0
