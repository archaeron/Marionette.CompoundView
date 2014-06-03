test:
	casperjs test tests/*

compile:
	cat src/MatchMediaEventStream.coffee src/CompoundView.coffee > build/CompoundView.coffee
	coffee -mc build/CompoundView.coffee
	coffee -mc example/example.coffee

.PHONY: test compile
