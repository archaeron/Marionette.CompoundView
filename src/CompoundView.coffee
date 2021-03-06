# options:
# - listView
# - itemView
# - listItemView
# - collection
createObservable = (element, event) ->
	Rx.Observable.fromEventPattern ((h) -> element.on event, h), ((h) -> element.off event, h)


class Marionette.CompoundView extends Marionette.Layout
	className: 'compound-view'

	regions:
		listViewContainer: ".list-view-container"
		singleElementViewContainer: '.single-element-container'

	@viewSizes:
		small: 'small'
		large: 'large'

	constructor: (options) ->
		super(options)
		@listenTo this, 'list-element:selected', (view) ->
			@renderSingleElement view.model


	hasHistorySupport: ->
		window.history?

	getListView: (collection) ->
		ListView = Marionette.getOption this, "listView"
		if ListView?
			new ListView
				collection: collection
		else
			listItemView = Marionette.getOption this, "listItemView"

			CollectionView = class extends Marionette.CollectionView
				itemView: listItemView

			new CollectionView
				collection: collection

	getCollection: ->
		Marionette.getOption this, "collection"

	getDetailView: ->
		Marionette.getOption this, "itemView"

	render: ->
		super()
		@renderLarge()


	renderRightSize: (screenSize) ->
		if screenSize is Marionette.CompoundView.viewSizes.large
			@renderLarge()
		else
			@renderSmall()



	renderSmall: ->

	renderLarge: ->
		@renderList()

		@listView.children.each (view) =>

			if view.addedToCompoundView?
				view.addedToCompoundView this


			view.delegateEvents
				'click': @itemSelected view

		if @listView.children.length > 0
			@listView.children.first().$el.click()

	renderList: ->
		@listView = @getListView @getCollection()

		@listViewContainer.show @listView

	renderSingleElement: (model) ->
		DetailView = @getDetailView()

		detailView = new DetailView
			model: model

		@singleElementViewContainer.show detailView

	initialEvents: ->
		@listenTo @getCollection(), "add", @itemAdded

	itemAdded: (model) ->
		console.log "Item added"
		listItemView = @listView.children.findByModel model
		console.log listItemView
		listItemView.delegateEvents
			'click': @itemSelected listItemView


	itemSelected: (view) ->
		=>
			if @selectedListItem?
				@selectedListItem.trigger 'list-element:unselected'

			@selectedListItem = view
			view.trigger 'list-element:selected'
			@trigger 'list-element:selected', view


#   // Configured the initial events that the composite view
#   // binds to. Override this method to prevent the initial
#   // events, or to add your own initial events.
#   _initialEvents: function(){
#     if (this.collection){
#       this.listenTo(this.collection, "add", this.addChildView, this);
#       this.listenTo(this.collection, "remove", this.removeItemView, this);
#       this.listenTo(this.collection, "reset", this._renderChildren, this);
#     }
#   },

#   // Retrieve the `itemView` to be used when rendering each of
#   // the items in the collection. The default is to return
#   // `this.itemView` or Marionette.CompositeView if no `itemView`
#   // has been defined
#   getItemView: function(item){
#     var itemView = Marionette.getOption(this, "itemView") || this.constructor;

#     if (!itemView){
#       throwError("An `itemView` must be specified", "NoItemViewError");
#     }

#     return itemView;
#   },

#   // Serialize the collection for the view.
#   // You can override the `serializeData` method in your own view
#   // definition, to provide custom serialization for your view's data.
#   serializeData: function(){
#     var data = {};

#     if (this.model){
#       data = this.model.toJSON();
#     }

#     return data;
#   },

#   // Renders the model once, and the collection once. Calling
#   // this again will tell the model's view to re-render itself
#   // but the collection will not re-render.
#   render: function(){
#     this.isRendered = true;
#     this.isClosed = false;
#     this.resetItemViewContainer();

#     this.triggerBeforeRender();
#     var html = this.renderModel();
#     this.$el.html(html);
#     // the ui bindings is done here and not at the end of render since they
#     // will not be available until after the model is rendered, but should be
#     // available before the collection is rendered.
#     this.bindUIElements();
#     this.triggerMethod("composite:model:rendered");

#     this._renderChildren();

#     this.triggerMethod("composite:rendered");
#     this.triggerRendered();
#     return this;
#   },

#   _renderChildren: function(){
#     if (this.isRendered){
#       Marionette.CollectionView.prototype._renderChildren.call(this);
#       this.triggerMethod("composite:collection:rendered");
#     }
#   },

#   // Render an individual model, if we have one, as
#   // part of a composite view (branch / leaf). For example:
#   // a treeview.
#   renderModel: function(){
#     var data = {};
#     data = this.serializeData();
#     data = this.mixinTemplateHelpers(data);

#     var template = this.getTemplate();
#     return Marionette.Renderer.render(template, data);
#   },

#   // Appends the `el` of itemView instances to the specified
#   // `itemViewContainer` (a jQuery selector). Override this method to
#   // provide custom logic of how the child item view instances have their
#   // HTML appended to the composite view instance.
#   appendHtml: function(cv, iv, index){
#     var $container = this.getItemViewContainer(cv);
#     $container.append(iv.el);
#   },

#   // Internal method to ensure an `$itemViewContainer` exists, for the
#   // `appendHtml` method to use.
#   getItemViewContainer: function(containerView){
#     if ("$itemViewContainer" in containerView){
#       return containerView.$itemViewContainer;
#     }

#     var container;
#     var itemViewContainer = Marionette.getOption(containerView, "itemViewContainer");
#     if (itemViewContainer){

#       var selector = _.isFunction(itemViewContainer) ? itemViewContainer() : itemViewContainer;
#       container = containerView.$(selector);
#       if (container.length <= 0) {
#         throwError("The specified `itemViewContainer` was not found: " + containerView.itemViewContainer, "ItemViewContainerMissingError");
#       }

#     } else {
#       container = containerView.$el;
#     }

#     containerView.$itemViewContainer = container;
#     return container;
#   },

#   // Internal method to reset the `$itemViewContainer` on render
#   resetItemViewContainer: function(){
#     if (this.$itemViewContainer){
#       delete this.$itemViewContainer;
#     }
#   }
# });
