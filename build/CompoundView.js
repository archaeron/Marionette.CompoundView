// Generated by CoffeeScript 1.7.1
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

    CompoundView.viewSizes = {
      small: 'small',
      large: 'large'
    };

    function CompoundView(options) {
      CompoundView.__super__.constructor.call(this, options);
      this.listenTo(this, 'list-element:selected', function(view) {
        return this.renderSingleElement(view.model);
      });
      this.smallScreenQuery = (options.breakWidth && this.hasHistorySupport() ? MediaMatcher.matchesEventStream("(max-width: " + options.breakWidth + "px)") : Bacon.once(false)).map((function(_this) {
        return function(isSmall) {
          if (isSmall) {
            return Marionette.CompoundView.viewSizes.small;
          } else {
            return Marionette.CompoundView.viewSizes.large;
          }
        };
      })(this));
    }

    CompoundView.prototype.hasHistorySupport = function() {
      return typeof history !== "undefined" && history !== null;
    };

    CompoundView.prototype.getListView = function(collection) {
      var CollectionView, ListView, listItemView;
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
            return _Class.__super__.constructor.apply(this, arguments);
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
      CompoundView.__super__.render.call(this);
      return this.smallScreenQuery.onValue((function(_this) {
        return function(screenSize) {
          return _this.renderRightSize(screenSize);
        };
      })(this));
    };

    CompoundView.prototype.renderRightSize = function(screenSize) {
      if (screenSize === Marionette.CompoundView.viewSizes.large) {
        return this.renderLarge();
      } else {
        return this.renderSmall();
      }
    };

    CompoundView.prototype.renderSmall = function() {};

    CompoundView.prototype.renderLarge = function() {
      this.renderList();
      this.listView.children.each((function(_this) {
        return function(view) {
          return view.delegateEvents({
            'click': _this.itemSelected(view)
          });
        };
      })(this));
      if (this.listView.children.length > 0) {
        return this.listView.children.first().$el.click();
      }
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

    CompoundView.prototype.itemSelected = function(view) {
      return (function(_this) {
        return function() {
          if (_this.selectedListItem != null) {
            _this.selectedListItem.trigger('list-element:unselected');
          }
          _this.selectedListItem = view;
          view.trigger('list-element:selected');
          return _this.trigger('list-element:selected', view);
        };
      })(this);
    };

    return CompoundView;

  })(Marionette.Layout);

}).call(this);

//# sourceMappingURL=CompoundView.map