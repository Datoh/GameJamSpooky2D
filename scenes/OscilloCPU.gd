extends StaticBody2D
class_name OscilloCPU

@onready var timer_node = $Timer
@onready var animation_player = $AnimationPlayer

@export var correct_values := [
    {"amplitude": 1, "frequency": 2},
    {"amplitude": 5, "frequency": -1}]

@export var values := [
    {"amplitude": 1, "frequency": 1},
    {"amplitude": 1, "frequency": 1}]

@export var on := false

var timer := 0.0
var timer_max := 0.0

signal display_oscillo(correct_values: Array)
signal timer_changed(timer: float, max: float)

func _ready():
  animation_player.play("on" if on else "off")


func action():
  if on:
    display_oscillo.emit(correct_values, values)


func enable(value: bool, timer_value: float):
  if value:
    timer = timer_value
    timer_max = timer_value
    timer_changed.emit(timer, timer_max)
    timer_node.start()
  on = value
  animation_player.play("on" if on else "off")


func _on_timer_timeout():
  timer -= timer_node.wait_time
  timer_changed.emit(timer, timer_max)
  if timer <= 0.0:
    timer_node.stop()
