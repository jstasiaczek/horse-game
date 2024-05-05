class_name GameTime

var minutes: int = 0

func clear():
    minutes = 0
func set_minutes(value: int):
    minutes = value
    SignalsService.on_time_changed.emit()
func add_minutes(value: int):
    set_minutes(minutes + value)
func add_hours(value: int):
    add_minutes(value * 60) 
func add_day(value: int):
    add_hours(24 * value)
func get_minutes() -> int:
    return minutes
func get_minute() -> int:
    return minutes % 60
func get_hour() -> int:
    return (minutes / 60) % 24
func get_day() -> int:
    return (minutes / 60) / 24
func get_day_string():
    if get_day() == 1:
        return "day"
    return "days"
func format():
    return "%4d %s %02d:%02d" % [get_day(), get_day_string(), get_hour(), get_minute()]