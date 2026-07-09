extends Node2D

@export var player: Player
@export var enemy: Enemy

@onready var reactionTimer: Timer = $ReactionTimer
var playerCounteredEnemy: bool = false
var enemyAttackedPlayer: bool = false
var isPlayerTurn: bool = true
var display_health: Label
var isGameOver: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $player
	enemy = $enemy
	var display_name = $Menu/MenuItems/PlayerInfo/Player1/Name
	display_health = $Menu/MenuItems/PlayerInfo/Player1/Health
	display_name.text = player.charname
	updateHealth()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not isGameOver:
		if player.isDead():
			isGameOver = true
		updateHealth()

func _on_attack_pressed() -> void:
	if not player.isDead() and isPlayerTurn:
		player.executeBattleAction(enemy)
		isPlayerTurn = false
		executeEnemyTurn()

func updateHealth() -> void:
	display_health.text = var_to_str(player.health) + '/' + var_to_str(player.max_health)
	
func executeEnemyTurn() -> void:
	enemy.executeBattleAction()

func _on_enemy_battle_action_completed() -> void:
	isPlayerTurn = true

func _on_enemy_attacked_player() -> void:
	enemyAttackedPlayer = true
	if reactionTimer.is_stopped():
		reactionTimer.start()

func _on_player_countered_enemy() -> void:
	playerCounteredEnemy = true
	if reactionTimer.is_stopped():
		reactionTimer.start()

func _on_reaction_timer_timeout() -> void:
	if enemyAttackedPlayer:
		if playerCounteredEnemy:
			print(player.charname, ' countered ', enemy.charname, '!')
		else:
			enemy.attackTarget(player)
	
	enemyAttackedPlayer = false
	playerCounteredEnemy = false
