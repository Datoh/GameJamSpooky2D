extends TextureRect
class_name ButtonBar

signal value_changed(value: int)

var step := 10
var value: int = 0

@export var can_be_negative := true
@export_range(0.0, 1.0) var max_button := 0.75

func _ready():
  pivot_offset = size / 2.0


func set_value(new_value: int):
  var min_value := -step if can_be_negative else 0
  var max_value := step
  if new_value > max_value:
    new_value = min_value
  elif new_value < min_value:
    new_value = max_value
  if value == new_value:
    return
  value = new_value
  var step_count = max(abs(min_value), max_value) + 1
  var rotation_step = PI * max_button / step_count
  rotation = value * rotation_step
  value_changed.emit(value)
