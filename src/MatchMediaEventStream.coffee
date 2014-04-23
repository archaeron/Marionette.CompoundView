matchMediaEventStream = (mediaQueryString) ->
	Rx.Observable.create (observer) ->
		mediaQueryListener = (mediaQuery) ->
			observer.onNext mediaQuery

		mediaQuery = window.matchMedia mediaQueryString
		observer.onNext mediaQuery
		mediaQuery.addListener mediaQueryListener
		->
			mediaQuery.removeListener mediaQueryListener


matchesEventStream = (mediaQueryString) ->
	matchMediaEventStream(mediaQueryString).map (mq) ->
		mq.matches


this.MediaMatcher =
	matchMediaEventStream: matchMediaEventStream
	matchesEventStream: matchesEventStream
