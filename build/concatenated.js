// Generated by CoffeeScript 1.6.3
(function() {
  var matchMediaEventStream, matchesEventStream,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  matchMediaEventStream = function(mediaQueryString) {
    return Bacon.fromBinder(function(sink) {
      var mediaQuery, mediaQueryListener;
      mediaQueryListener = function(mediaQuery) {
        return sink(mediaQuery);
      };
      mediaQuery = window.matchMedia(mediaQueryString);
      sink(mediaQuery);
      mediaQuery.addListener(mediaQueryListener);
      return function() {
        return mediaQuery.removeListener(mediaQueryListener);
      };
    });
  };

  matchesEventStream = function(mediaQueryString) {
    return matchMediaEventStream(mediaQueryString).map(function(mq) {
      return mq.matches;
    });
  };

  this.MediaMatcher = {
    matchMediaEventStream: matchMediaEventStream,
    matchesEventStream: matchesEventStream
  };

  Marionette.CompoundView = (function(_super) {
    __extends(CompoundView, _super);

    CompoundView.prototype.className = 'compound-view';

    CompoundView.prototype.regions = {
      listViewContainer: ".list-view-container",
      singleElementViewContainer: '.single-element-container'
    };

    function CompoundView(options) {
      CompoundView.__super__.constructor.call(this, options);
      this.listenTo(this, 'list-element:selected', function(view) {
        return this.renderSingleElement(view.model);
      });
      this.smallScreenQuery = options.breakWidth && this.hasHistorySupport() ? MediaMatcher.matchesEventStream("(max-width: " + options.breakWidth + "px)") : Bacon.once(false);
    }

    CompoundView.prototype.hasHistorySupport = function() {
      return typeof history !== "undefined" && history !== null;
    };

    CompoundView.prototype.getListView = function(collection) {
      var CollectionView, ListView, listItemView, _ref;
      ListView = Marionette.getOption(this, "listView");
      if (ListView != null) {
        return new ListView({
          collection: collection
        });
      } else {
        listItemView = Marionette.getOption(this, "listItemView");
        CollectionView = (function(_super1) {
          __extends(_Class, _super1);

          function _Class() {
            _ref = _Class.__super__.constructor.apply(this, arguments);
            return _ref;
          }

          _Class.prototype.itemView = listItemView;

          return _Class;

        })(Marionette.CollectionView);
        return new CollectionView({
          collection: collection
        });
      }
    };

    CompoundView.prototype.getCollection = function() {
      return Marionette.getOption(this, "collection");
    };

    CompoundView.prototype.getDetailView = function() {
      return Marionette.getOption(this, "itemView");
    };

    CompoundView.prototype.render = function() {
      var _this = this;
      CompoundView.__super__.render.call(this);
      this.renderList();
      this.listView.children.each(function(view) {
        return view.delegateEvents({
          'click': function() {
            view.trigger('list-element:selected');
            return _this.trigger('list-element:selected', view);
          }
        });
      });
      return this.renderSingleElement(this.getCollection().first());
    };

    CompoundView.prototype.renderList = function() {
      this.listView = this.getListView(this.getCollection());
      return this.listViewContainer.show(this.listView);
    };

    CompoundView.prototype.renderSingleElement = function(model) {
      var DetailView, detailView;
      DetailView = this.getDetailView();
      detailView = new DetailView({
        model: model
      });
      return this.singleElementViewContainer.show(detailView);
    };

    return CompoundView;

  })(Marionette.Layout);

}).call(this);
