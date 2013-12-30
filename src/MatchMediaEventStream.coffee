matchMediaEventStream = (mediaQueryString) ->
	Bacon.fromBinder (sink) ->
		mediaQueryListener = (mediaQuery) ->
			sink(mediaQuery)

		mediaQuery = window.matchMedia mediaQueryString
		sink(mediaQuery)
		mediaQuery.addListener mediaQueryListener
		->
			mediaQuery.removeListener mediaQueryListener


matchesEventStream = (mediaQueryString) ->
	matchMediaEventStream(mediaQueryString).map (mq) ->
		mq.matches


this.MediaMatcher =
	matchMediaEventStream: matchMediaEventStream
	matchesEventStream: matchesEventStream
