extends Node2D

func print_midi_info(midi_event):
	return str(midi_event)\
		#+ ": Channel " + str(midi_event.channel)\
		#+ ", Controller number: " + str(midi_event.controller_number)\
		#+ ", Controller value: " + str(midi_event.controller_value)\
		+ ", Message " + str(midi_event.message)\
		+ ", Pitch " + str(midi_event.pitch)\
		+ ", Velocity " + str(midi_event.velocity)\
		+ ", Instrument " + str(midi_event.instrument)\
		+ ", Pressure " + str(midi_event.pressure)

func _ready() -> void:
	OS.open_midi_inputs()
	for device in OS.get_connected_midi_inputs():
		$TextEdit.text = device + "\n" + $TextEdit.text
	$TextEdit.text = str(OS.get_connected_midi_inputs().size()) + " devices connected\n" + $TextEdit.text
	globalTime = Time.get_unix_time_from_system() * 10

var time = 0
var delay = 0
var lastDelay = 0
var globalTime:float

func _process(delta: float) -> void:
	var tempTime:float = Time.get_unix_time_from_system() * 10
	var tempDelay = (tempTime - globalTime) * $HSlider.value
	lastDelay = delay
	globalTime = tempTime
	delay = tempDelay
	time += delay
	$ColorRect.queue_redraw()

func _input(event: InputEvent) -> void:
	if event is InputEventMIDI:
		$TextEdit.text = print_midi_info(event) + "\n" + $TextEdit.text
		var lineCount = $TextEdit.get_line_count()
		if lineCount > 100:
			for i in lineCount - 100:
				$TextEdit.remove_line_at(lineCount - i - 1)
