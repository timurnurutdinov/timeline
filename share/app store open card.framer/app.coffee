# Import from Figma
# Generated with Framer Inventory

figmaView = new Layer
	name: "figmaView"
	x: 0
	y: 0
	width: 375
	height: 667
	opacity: 1
	backgroundColor: "transparent"


bg = new Layer
	name: "bg"
	parent: figmaView
	x: 0
	y: 0
	width: 375
	height: 667
	opacity: 1
	image: "images/figma/bg.png"


tabBar = new Layer
	name: "tabBar"
	parent: figmaView
	x: 0
	width: 375
	height: 49
	opacity: 1
	image: "images/figma/tabBar.png"

tabBar.states =
	"feed":
		y: 618
	"article":
		y: 677


card = new Layer
	name: "card"
	parent: figmaView
	opacity: 1
	backgroundColor: "transparent"

card.states =
	"feed":
		x: 20
		y: 114
		width: 335
		height: 412
	"article":
		x: 0
		y: 0
		width: 375
		height: 667


image = new Layer
	name: "image"
	parent: card
	x: 0
	y: 0
	opacity: 1
	image: "images/figma/image.png"

image.states =
	"feed":
		width: 335.0
		height: 596
	"article":
		width: 375
		height: 667


subtitle = new Layer
	name: "subtitle"
	parent: card
	x: 0
	width: 335
	height: 18
	opacity: 1
	image: "images/figma/subtitle.png"

subtitle.states =
	"feed":
		y: 378
	"article":
		y: 458


title = new Layer
	name: "title"
	parent: card
	x: 0
	width: 335
	height: 64
	opacity: 1
	image: "images/figma/title.png"

title.states =
	"feed":
		y: 9
	"article":
		y: 18


close = new Layer
	name: "close"
	parent: card
	y: 20
	width: 28
	height: 28
	image: "images/figma/close.png"

close.states =
	"feed":
		x: 287
		opacity: 0
	"article":
		x: 327
		opacity: 1


sceneStates = ["feed", "article"]
sceneLayers = [figmaView, bg, tabBar, card, image, subtitle, title, close]

for item in sceneLayers
	try item.stateSwitch(sceneStates[0])


cycler = Utils.cycle(sceneStates)
nextState = cycler()

nextStateHandler = () ->
	nextState = cycler()
	for item in sceneLayers
		try
			item.animate(nextState, curve: Spring(damping: 1), time: 0.5)
		catch error


figmaView.on Events.Click, ->
	nextStateHandler()


# Blur

blur = new Layer
	width: figmaView.width
	height: figmaView.height
	parent: figmaView
	backgroundColor: "rgba(255,255,255,0)"
	opacity: 0

blur.states =
	"feed":
		opacity: 0
	"article":
		opacity: 1

blur.placeBefore(bg)
blur.style =
	"-webkit-backdrop-filter": "blur(17px)"

# Add Layer to plugin logic
sceneLayers.push(blur)

# Presenter

figmaView.clip = true
figmaView.borderRadius = 6

Framer.Extras.Hints.disable()
Canvas.backgroundColor = "#222"

if Canvas.width > 440
	figmaView.scale = (Canvas.height - 200) / 640
	figmaView.center()

card.clip = true

card.states.feed.borderRadius = 13
card.states.article.borderRadius = 0
card.stateSwitch("feed")


card.on Events.TouchStart, ->
	card.animate(scale: 0.96, time: 0.1)

card.on Events.TouchEnd, ->
	card.animate(scale: 1.0)



# Override Handler
nextStateHandler = () ->
	nextState = cycler()
	for item in sceneLayers
		try
			
			# Card separate animation
			if item is card
				item.animate(height: item.states[nextState].height, options: { curve: Spring(tension: 400, friction: 40) })
				item.animate(y: item.states[nextState].y, options: { curve: Spring(tension: 100, friction: 20, velocity: 22) })
				
				
				item.animate(width: item.states[nextState].width, options: { curve: Spring(damping: 1), time: 0.3, delay: 0.05 })
				item.animate(x: item.states[nextState].x, options: { curve: Spring(damping: 1), time: 0.5, delay: 0.05 })
				
				item.animate(borderRadius: item.states[nextState].borderRadius, options: { curve: Spring(damping: 1), time: 0.5 })
			
			# Special state for "close" layer appear
			else if item is close
				if nextState is "article" then item.opacity = 1
				item.animate(nextState, curve: Spring(damping: 1), time: 0.5)
			
			# Default animation for others
			else
				item.animate(nextState, curve: Spring(damping: 1), time: 0.5)
		
		catch error
