extends TextureRect

@export_range(0, 30) var step := 10
@export var context : Node2D = null

@onready var progress_bar = $ProgressBar

var correct_values := Array()
var ok := false

var bars : Array[Bar] = []
var current_bar := 0

var _last_action_time = 0
var _last_action = ""
const DELAY_BETWEEN_ACTION = 100

signal out(context: Node2D, ok: bool, values: Array)


func _ready():
  # for debug purpose
  Time.get_unix_time_from_system()
  init(null,
    [
      {"amplitude": 1, "frequency": 2},
      {"amplitude": 5, "frequency": -1},
    ],
    [
      {"amplitude": 1, "frequency": 1},
      {"amplitude": 1, "frequency": 1},
    ])


func _physics_process(_delta):
  if not visible:
    return
  var current_time := Time.get_ticks_msec()
  if Input.is_action_just_pressed("ui_cancel"):
    var values = Array()
    for bar in bars:
      values.append({"amplitude": bar.amplitude.value, "frequency": bar.frequency.value})
    progress_bar.max_value = 0
    out.emit(context, ok, values)
  elif Input.is_action_just_pressed("ui_focus_prev") or Input.is_action_just_pressed("ui_accept"):
    current_bar = (current_bar + 1) % bars.size()
    _last_action = ""
  elif Input.is_action_just_pressed("ui_focus_next"):
    current_bar = (current_bar - 1) if current_bar > 0 else bars.size() - 1
    _last_action = ""
  elif _is_action_ok("ui_up", current_time):
    var bar = bars[current_bar]
    bar.set_values(bar.amplitude.value + 1, bar.frequency.value)
  elif _is_action_ok("ui_down", current_time):
    var bar = bars[current_bar]
    bar.set_values(bar.amplitude.value - 1, bar.frequency.value)
  elif _is_action_ok("ui_left", current_time):
    var bar = bars[current_bar]
    bar.set_values(bar.amplitude.value, bar.frequency.value - 1)
  elif _is_action_ok("ui_right", current_time):
    var bar = bars[current_bar]
    bar.set_values(bar.amplitude.value, bar.frequency.value + 1)

func _is_action_ok(action: String, current_time: int) -> bool:
  if (current_time > _last_action_time + DELAY_BETWEEN_ACTION or _last_action != action) and Input.is_action_pressed(action):
    _last_action = action
    _last_action_time = current_time
    return true
  return false

func init(new_context: Node2D, new_correct_values: Array, new_values: Array):
  bars = [ $Bar1, $Bar2, $Bar3 ]
  assert(new_correct_values.size() == new_values.size())
  assert(new_correct_values.size() <= bars.size())
  context = new_context
  correct_values = new_correct_values
  for bar in bars:
    bar.set_values(0, 0)
    bar.step = step
    bar.visible = true
  bars.resize(correct_values.size())
  for i in range(new_values.size()):
    bars[i].set_values(new_values[i].amplitude, new_values[i].frequency)
  $BarResult.step = step
  $BarResult.set_correct_values(correct_values)
  current_bar = clamp(current_bar, 0, bars.size() - 1)


func _on_bar_result(ok_value: bool):
  $Ok.visible = ok_value
  ok = ok_value


func _on_timer_changed(timer: float, timer_max: float):
  progress_bar.max_value = timer_max
  progress_bar.value = timer
