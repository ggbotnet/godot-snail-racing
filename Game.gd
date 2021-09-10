extends Node2D

var btn_counter = 0
var player_speed = 0
var opponent_one_speed = RandomNumberGenerator.new()
var opponent_two_speed = RandomNumberGenerator.new()

var press_play = false
var press_cont = false
var the_end = false
var cont_reset = false
var first_player = false
var first_opponent_one = false
var first_opponent_two = false

onready var timer = $Timer
onready var timer_btn_reset = $TimerBtnReset
onready var timer_opponent_one = $TimerOpponentOne
onready var timer_opponent_two = $TimerOpponentTwo
onready var timer_continue = $TimerContinue

onready var gui_time = $GUI/C/Time
onready var gui_time_b = $GUI/C/TimeBest
onready var gui_mashing = $GUI/C/Mashing
onready var gui_btn_progress = $GUI/C/Mashing/BtnProgress
onready var gui_press_play = $GUI/C/PressPlay
onready var gui_press_cont = $GUI/C/PressCont
onready var gui_winner = $GUI/C/Winner
onready var gui_go = $GUI/C/GO
onready var animation_player = $AnimationPlayer

onready var s_player = $Player
onready var s_opponent_one = $OpponentOne
onready var s_opponent_two = $OpponentTwo

func _ready() -> void:
	gui_press_play.show()
	gui_mashing.hide()
	gui_press_cont.hide()
	gui_go.hide()
	gui_winner.rect_position.x = 48
	gui_winner.rect_position.y = -16
	s_player.position.x = 16
	s_player.position.y = 152
	s_opponent_one.position.x = 16
	s_opponent_one.position.y = 112
	s_opponent_two.position.x = 16
	s_opponent_two.position.y = 72
	gui_time_b.text = str(Global.time_best)
	animation_player.play("press_play")

func _physics_process(_delta: float) -> void:
	gui_time.text = str(Global.time)
	if first_opponent_one == false and first_opponent_two == false and cont_reset == false:
		if s_player.position.x > 239:
			s_player.position.x = 240
			TheEnd()
			first_player = true
	if first_player == false and first_opponent_two == false and cont_reset == false:
		if s_opponent_one.position.x > 239:
			s_opponent_one.position.x = 240
			TheEnd()
			first_opponent_one = true
	if first_player == false and first_opponent_one == false and cont_reset == false:
		if s_opponent_two.position.x > 239:
			s_opponent_two.position.x = 240
			TheEnd()
			first_opponent_two = true
	if first_player == true:
		gui_winner.rect_position.y = 144
	if first_opponent_one == true:
		gui_winner.rect_position.y = 104
	if first_opponent_two == true:
		gui_winner.rect_position.y = 64
	if timer_continue.is_stopped():
		if the_end == true:
			timer_continue.start()
		if first_player == true and the_end == true:
			if Global.time < Global.time_best:
				Global.time_best = Global.time
	if press_play == true:
		if btn_counter == 0:
			gui_btn_progress.value = 0
		if btn_counter >= 1:
			player_speed = 1
			gui_btn_progress.value = 1
		if btn_counter > 2:
			player_speed = 2
			gui_btn_progress.value = 2
		if btn_counter > 3:
			player_speed = 3
			gui_btn_progress.value = 3
		if btn_counter > 4:
			player_speed = 4
			gui_btn_progress.value = 4
		if btn_counter > 5:
			player_speed = 5
			gui_btn_progress.value = 5
		if btn_counter > 6:
			player_speed = 6
			gui_btn_progress.value = 6

func _input(event: InputEvent) -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if press_play == false:
		if event.is_action_pressed("keyboard_spacebar"):
			gui_go.show()
			press_play = true
			animation_player.stop()
			gui_press_play.hide()
			gui_mashing.show()
			timer.start()
			timer_btn_reset.start()
			timer_opponent_one.start()
			timer_opponent_two.start()
			yield(get_tree().create_timer(0.4), "timeout")
			gui_go.hide()
	if press_play == true and first_player == false and first_opponent_one == false and first_opponent_two == false:
		if event.is_action_pressed("keyboard_spacebar"):
				s_player.transform.origin.x += player_speed
				btn_counter += 1
	if cont_reset == true:
		if event.is_action_pressed("keyboard_spacebar"):
			animation_player.stop()
			Global.Reset()
			get_tree().reload_current_scene()
	if event.is_action_pressed("keyboard_esc"):
		get_tree().quit()

func TheEnd():
	timer.stop()
	timer_btn_reset.stop()
	timer_opponent_one.stop()
	timer_opponent_two.stop()
	gui_mashing.hide()
	press_cont = true
	the_end = true

func _on_TimerContinue_timeout() -> void:
	gui_press_cont.show()
	animation_player.play("press_cont")
	the_end = false
	cont_reset = true

func _on_TimerButtonReset_timeout() -> void:
	btn_counter = 0

func _on_Timer_timeout() -> void:
	Global.time += 1

func _on_TimerOpponentOne_timeout() -> void:
	opponent_one_speed.randomize()
	var opponent_one_speed_random = opponent_one_speed.randi_range(1, 6)
	s_opponent_one.transform.origin.x += opponent_one_speed_random
	timer_opponent_one.wait_time = rand_range(0.1,0.3)

func _on_TimerOpponentTwo_timeout() -> void:
	opponent_two_speed.randomize()
	var opponent_two_speed_random = opponent_two_speed.randi_range(1, 6)
	s_opponent_two.transform.origin.x += opponent_two_speed_random
	timer_opponent_two.wait_time = rand_range(0.1,0.3)
