window.showNumber = (nStr) ->
	nStr += ''
	x = nStr.split '.'
	x1 = x[0];
	x2 =  if x.length > 1 then '.' + x[1] else ''
	rgx = /(\d+)(\d{3})/
	while rgx.test(x1)
		x1 = x1.replace(rgx, '$1' + "'" + '$2')
	x1 + x2

MyApp = new Backbone.Marionette.Application();
MyApp.addRegions
	compoundViewContainer: "#compound-view-container"

class ListItemView extends Backbone.Marionette.ItemView
	tagName: 'li'
	className: 'list-group-item'
	template: '#list-item-view'

	initialize: ->
		@listenTo @, 'list-element:selected', @selected
		@listenTo @, 'list-element:unselected', @unselected

	selected: ->
		@$el.addClass 'selected'

	unselected: ->
		@$el.removeClass 'selected'

class ListCompositeView extends Backbone.Marionette.CompositeView
	itemView: ListItemView
	template: '#list-view'
	itemViewContainer: ".list"

class ItemView extends Backbone.Marionette.ItemView
	template: '#item-view'
	className: 'panel panel-default'


class Model extends Backbone.Model

class Collection extends Backbone.Collection
	model: Model
	comparator: (model) ->
		model.get 'name'

window.c = collection = new Collection [
		{name: 'Australia', population: 22.68e6, landArea: 7.618e6}
		{name: 'Switzerland', population: 7.997e6, landArea: 39997}
		{name: 'Italy', population: 60.92e6, landArea: 294140}
		{name: 'Argentina', population: 41.09e6, landArea: 2.737e6}
		{name: 'South Korea', population: 48.8e6, landArea: 98190}
	]

cV = new Marionette.CompoundView
	listView: ListCompositeView
	itemView: ItemView
	collection: collection
	template: '#compound-view'
	breakWidth: 750

console.log cV


$(document).ready ->
	MyApp.compoundViewContainer.show cV
