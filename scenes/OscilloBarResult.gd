extends TextureRect
class_name BarResult

@export var correct_curve_color : Color = Color.BLACK
@export var correct_curve_size : int = 2

@export var curve_color : Color = Color.BLACK
@export var curve_size : int = 2

var _correct_bar_values = []

var _bar_values = {}
var _correct_points = []

var step := 10

var ok := false

signal result(ok: bool)

func set_correct_values(correct_bar_values: Array):
  _correct_bar_values = correct_bar_values
  var y_factor = size.y / 2.0 / step
  var x_factor = (4.0 * PI) / (size.x - pivot_offset.x)
  var y_min = -size.y / 2.0
  var y_max = size.y / 2.0
  for i in range(size.x - pivot_offset.x):
    var y := 0.0
    for correct_bar_value in _correct_bar_values:
      y += -correct_bar_value.amplitude * y_factor * sin(correct_bar_value.frequency * x_factor * i)
    _correct_points.append(Vector2(i, clampf(y, y_min, y_max)))

  queue_redraw()


func _draw():
  var new_ok = true
  var y_factor = size.y / 2.0 / 10.0
  var x_factor = (4.0 * PI) / (size.x - pivot_offset.x)
  var y_min = -size.y / 2.0
  var y_max = size.y / 2.0
  var previous_point := Vector2.ZERO
  for i in range(size.x - pivot_offset.x):
    var y := 0.0
    for bar_index in _bar_values:
      var bar_value = _bar_values[bar_index]
      y += -bar_value.amplitude * y_factor * sin(bar_value.frequency * x_factor * i)
    var point = pivot_offset + Vector2(i, clampf(y, y_min, y_max))
    if i > 0:
      draw_line(previous_point, point, curve_color, curve_size)
    previous_point = point

    if i > 0:
      draw_line(pivot_offset + _correct_points[i - 1], pivot_offset + _correct_points[i], correct_curve_color, correct_curve_size)

    new_ok = new_ok and point == pivot_offset + _correct_points[i]

  if ok != new_ok:
    ok = new_ok
    result.emit(ok)


func _on_bar_values_changed(bar_index: int, amplitude: float, frequency: float):
  _bar_values[bar_index] = { "amplitude": amplitude, "frequency": frequency }
  queue_redraw()

