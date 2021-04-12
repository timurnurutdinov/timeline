Canvas.backgroundColor = "222"
v = 60

niceValue = (number) ->
	return "#{number.toFixed()} dp"

# Colors

shuffle = (source) ->
	return source unless source.length >= 2
	for index in [source.length-1..1]
		randomIndex = Math.floor Math.random() * (index + 1)
		[source[index], source[randomIndex]] = [source[randomIndex], source[index]]
	return source

angles = [0, 12, 15, 24, 30, 45, 60, 72, 90, 110, 125, 140, 155, 180]

data = [
	{ start: "#FEAC5E", end: "#C779D0" },
	{ start: "#FEAC5E", end: "#4BC0C8" },
	{ start: "#43cea2", end: "#185a9d" },
	{ start: "#FFA17F", end: "#00223E" },
	{ start: "#360033", end: "#0b8793" },
	{ start: "#948E99", end: "#2E1437" },
	{ start: "#73C8A9", end: "#373B44" },
	{ start: "#abaabb", end: "#ffffff" },
	{ start: "#83a4d4", end: "#b6fbff" },
	{ start: "#00c6ff", end: "#0072ff" },
	{ start: "#70e1f5", end: "#ffd194" },
	{ start: "#556270", end: "#ff6b6b" },
	{ start: "#9d50bb", end: "#6e48aa" },
	{ start: "#f0c27b", end: "#4b1248" },
	{ start: "#606c88", end: "#3f4c6b" },
	{ start: "#649173", end: "#dbd5a4" },
]

shuffle(data)

screenGradients = []
for currentData in data
	screenGradients.push new Gradient {
		start: new Color(currentData.start)
		end: new Color(currentData.end)
		angle: Utils.randomChoice(angles)
	}


gradientView = new Layer
	width: Screen.width
	height: Screen.height

for currentGradient, i in screenGradients
	gradientView.states["#{i}"] = 
		gradient: currentGradient
		opacity: 1
		animationOptions:
			time: 5
			curve: Bezier.linear

delete gradientView.states.default

gradientView.on Events.StateSwitchEnd, (from, to) ->
	currentIndex = @stateNames.indexOf to
	currentIndex++
	if currentIndex >= @stateNames.length then currentIndex = 0
	@animate(@stateNames["#{currentIndex}"])

gradientView.stateSwitch(gradientView.stateNames[gradientView.stateNames.length - 1])

# View
measureView = (measure, value) ->
	view = new Layer
		backgroundColor: "null"
		width: Screen.width
	
	title = new TextLayer
		parent: view
		width: Screen.width
		height: 40
		text: "#{measure}:"
		fontSize: 20
		textAlign: "left"
		fontWeight: "bold"
		color: "white"
		opacity: 0.5
		padding: 
			left: 84 + 20
	
	text = new TextLayer
		parent: view
		y: 24
		width: Screen.width
		text: niceValue(value)
		fontFamily: Utils.loadWebFont "Rubik"
		fontSize: 54
		textAlign: "left"
		fontWeight: "bold"
		color: "white"
		padding:
			left: 80 + 20
		shadowX: 4
		shadowY: 4
		shadowBlur: 20
		shadowColor: "rgba(0,0,0,0.06)"
	
	view.height = text.y + text.height
	return view



widthView = measureView("width", Screen.width)
heightView = measureView("height", Screen.height)

widthView.y = Align.center(-v)
heightView.y = Align.center(v)

Screen.onResize ->
	widthView.children[1].text = niceValue(Screen.width)
	heightView.children[1].text = niceValue(Screen.height)
	
	gradientView.width = Screen.width
	gradientView.height = Screen.height
