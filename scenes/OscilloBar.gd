extends TextureRect
class_name Bar

@onready var amplitude: ButtonBar = %Amplitude
@onready var frequency: ButtonBar = %Frequency

@export var bar_index : int = 0
@export var curve_color : Color = Color.BLACK
@export var curve_size : int = 2

var step := 0

signal values_changed(bar_index: int, amplitude: int, frequency: int)

func _ready():
  queue_redraw()


func set_values(new_amplitude: int, new_frequency: int):
  amplitude.set_value(new_amplitude)
  frequency.set_value(new_frequency)
  queue_redraw()


func _draw():
  var y_factor = size.y / 2.0 / step
  var x_factor = (4.0 * PI) / (size.x - pivot_offset.x)
  var y_min = -size.y / 2.0
  var y_max = size.y / 2.0
  var previous_point := Vector2.ZERO
  for i in range(size.x - pivot_offset.x):
    var y = -amplitude.value * y_factor * sin(frequency.value * x_factor * i)
    var point = pivot_offset + Vector2(i, clampf(y, y_min, y_max))
    if i > 0:
      draw_line(previous_point, point, curve_color, curve_size)
    previous_point = point


func _on_amplitude_value_changed(value: int):
  values_changed.emit(bar_index, amplitude.value, frequency.value)
  queue_redraw()


func _on_frequency_value_changed(value: int):
  values_changed.emit(bar_index, amplitude.value, frequency.value)
  queue_redraw()
