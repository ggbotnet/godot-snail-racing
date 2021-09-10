extends Node

var time = 0
var time_best = 99 setget time_best_set

const file_dir = "user://time.data"

onready var music = $Music

func _ready() -> void:
	music.play()
	time_load()

func Reset():
	time = 0

func time_best_set(new_time):
	time_best = new_time
	time_save()

func time_save():
	var file = File.new()
	file.open(file_dir, file.WRITE)
	file.store_var(time_best)
	file.close()

func time_load():
	var file = File.new()
	if not file.file_exists(file_dir): return
	file.open(file_dir, File.READ)
	time_best = file.get_var()
	file.close()
