test:
	casperjs test tests/*

compile:
	cat src/MatchMediaEventStream.coffee src/CompoundView.coffee > build/concatenated.coffee
	coffee -c build/concatenated.coffee
