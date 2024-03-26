extends Node

static func map(function, i_array: Array)->Array:
	var o_array := []
	for value in i_array:
		o_array.append(function.call_func(value))
	return o_array

static func filter(filter_function, candidate_array: Array)->Array:
	var filtered_array := []

	for candidate_value in candidate_array:
		if filter_function.call_func(candidate_value):
			filtered_array.append(candidate_value)

	return filtered_array

static func reduce(function, i_array: Array, first = null):
	var acc = first
	var start := 0
	if acc == null:
		acc = i_array[0]
		start = 1
	for index in range(start,i_array.size()):
		acc = function.call_func(acc,i_array[index])
	return acc

static func pick_random(i_array: Array):
	var random_index = randi() % i_array.size()
	return i_array[random_index]
