extends Node

const BEARER = ""
var turn_off_scenario_link=""
var turn_on_scenario_link=""

# Declare an HTTPRequest node
var http_request: HTTPRequest

# Flag to track if a request is in progress
var is_requesting: bool = false

func _ready():
	if not(BEARER and turn_off_scenario_link and turn_on_scenario_link ):
		printerr("Enter bearer ans scenario links")
	# Create the HTTPRequest node and add it to the scene tree
	http_request = HTTPRequest.new()
	add_child(http_request)
	
	# Connect the request_completed signal to handle the response
	http_request.request_completed.connect(self._on_request_completed)

func turn_off_bulp():
	send_bulp_request(turn_off_scenario_link)

func turn_on_bulp():
	send_bulp_request(turn_on_scenario_link)

func send_bulp_request(scenario_id: String):
	if is_requesting:
		print("Request is still processing. Please wait.")
		return

	# Set the flag to indicate a request is in progress
	is_requesting = true
	
	# Base URL for the API request
	var base_url = "https://api.iot.yandex.net/v1.0/scenarios/"
	
	# Complete URL with the scenario ID
	var url = base_url + scenario_id + "/actions"
	
	# Set up the headers using PackedStringArray
	var headers = PackedStringArray(["User-Agent: insomnia/9.3.3", "Authorization: Bearer " + BEARER])
	
	# The body payload as a string (if needed)
	var body = ""

	# Make the POST request to the constructed URL
	var result = http_request.request(url, headers, HTTPClient.METHOD_POST, body)

	# Check if the request was successful
	if result != OK:
		print("Request failed: ", result)
		# Reset the flag as the request failed
		is_requesting = false

func _on_request_completed(result, response_code, headers, body):
	# Reset the flag to allow new requests
	is_requesting = false

	if result == OK:
		# Print the response from the server
		print("Response: ", body.get_string_from_utf8())
	else:
		print("Request failed with result: ", result)
