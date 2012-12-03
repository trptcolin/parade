function ListMenu(s) {
  this.slide = s
  this.typeName = 'ListMenu'
  this.itemLength = 0;
  this.items = new Array();
  this.addItem = function (key, text, slide) {
    if (key.length > 1) {
      thisKey = key.shift()
      if (!this.items[thisKey]) {
        this.items[thisKey] = new ListMenu(slide)
      }
      this.items[thisKey].addItem(key, text, slide)
    } else {
      thisKey = key.shift()
      this.items[thisKey] = new ListMenuItem(text, slide)
    }
  }
  this.getList = function() {
    var newMenu = $("<ul>")
    for(var i in this.items) {
      var item = this.items[i]
      var domItem = $("<li>")
      if (item.typeName == 'ListMenu') {
        choice = $("<a rel=\"" + (item.slide - 1) + "\" href=\"#\">" + i + "</a>")
        domItem.append(choice)
        domItem.append(item.getList())
      }
      if (item.typeName == 'ListMenuItem') {
        choice = $("<a rel=\"" + (item.slide - 1) + "\" href=\"#\">" + item.slide + '. ' + item.textName + "</a>")
        domItem.append(choice)
      }
      newMenu.append(domItem)
    }
    return newMenu
  }
}

function ListMenuItem(t, s) {
  this.typeName = "ListMenuItem"
  this.slide = s
  this.textName = t
}


$(document).ready(function() {

  window.Preshow = Spine.Class.create({
    init: function() {
      this.element = $(arguments[0]);
      this.secondsToRun = parseFloat(arguments[1] * 60);

      $.subscribe("presentation:preshow:toggle",$.proxy(function() {
        this.toggle();
      },this));

    },
    preshowRunning: false,
    start: function() {

      if (this.preshowIntervalReference) {
        return;
      }

      this.preservePresentationSpace();

      this.load();

      this.images = this.element.children("img");

      this.currentImageIndex = 0;
      this.totalImages = this.images.size();


      this.preshowRunning = true;

      $.publish("presentation:preshow:start");

      this.currentRunTime = 0;
      this.currentRemainingTime = this.secondsToRun;

      this.nextImage();
      this.preshowIntervalReference = setInterval($.proxy(this.perform,this),1000);

    },
    preservePresentationSpace: function() {
      this.storedPresentationSpace = this.element.html();
    },
    restorePresentationSpace: function() {
      this.element.empty();
      this.element.html(this.storedPresentationSpace);
    },
    displayImagesInterval: 5,
    perform: function() {
      this.currentRunTime ++;
      this.currentRemainingTime --;

      time = this.secondsToTime(this.currentRemainingTime);

      $('#preshow_timer').text(time + ' to go-time')
      var description = this.preshowDescription && this.preshowDescription[tmpImg.attr("ref")]

      if(description) {
        $('#tips').show();
        $('#tips').text(description);
      } else {
        $('#tips').hide();
      }

      if ((this.currentRunTime % this.displayImagesInterval) == 0) {
        this.nextImage();
      }

      this.preshowTip();

      if (this.currentRemainingTime <= 0) {
        this.stop();
      }

    },
    stop: function() {

      if (!this.preshowIntervalReference) {
        return;
      }

      this.preshowRunning = false;
      window.clearInterval(this.preshowIntervalReference);
      this.preshowIntervalReference = undefined;

      $('#preshow').remove();
      $('#tips').remove();
      $('#preshow_timer').remove();

      this.restorePresentationSpace();

      $.publish("presentation:preshow:stop");

    },
    toggle: function() {

      if (this.preshowIntervalReference) {
        this.stop();
      } else {
        this.start();
      }

    },
    preshowPath: "preshow",
    load: function() {

      $.getJSON(this.preshowPath, false, $.proxy(function(data) {

        this.element.after("<div id='preshow'></div><div id='tips'></div><div id='preshow_timer'></div>")

        $.each(data, $.proxy(function(i, n) {
          if(n == "preshow.json") {
            // has a descriptions file
            $.getJSON("/file/preshow/preshow.json", false, function(data) {
              this.preshowDescription = data;
            })
          } else {
            $('#preshow').append('<img ref="' + n + '" src="/file/preshow/' + n + '"/>');
            this.images = $("#preshow > img");
            this.totalImages = this.images.size();
          }
        },this));

      },this));

    },
    nextImage: function() {
      this.currentImageIndex ++;
      if((this.currentImageIndex + 1) > this.totalImages) {
        this.currentImageIndex = 0;
      }

      this.element.empty();
      tmpImg = this.images.eq(this.currentImageIndex).clone();
      $(tmpImg).attr('width', '1020');
      this.element.html(tmpImg);
    },
    preshowTip: function() {

    },
    secondsToTime: function(seconds) {
      minutes = Math.floor(seconds / 60)
      seconds = seconds - (minutes * 60)
      if(seconds < 10) {
        seconds = "0" + seconds
      }
      return minutes + ":" + seconds
    }
  });

  window.ToggleView = Spine.Class.create({
    init: function () {

      this.element = $(arguments[0])

      var eventPrefix = arguments[1]

      $.subscribe( eventPrefix + ":show",$.proxy(function() {
        this.show()
      },this));

      $.subscribe( eventPrefix + ":hide",$.proxy(function() {
        this.hide()
      },this));

      $.subscribe( eventPrefix + ":toggle",$.proxy(function() {
        this.toggle()
      },this));

    },
    show: function() {
      this.element.show()
    },
    hide: function() {
      this.element.hide()
    },
    toggle: function() {
      this.element.toggle()
    }
  });

  window.Footer = ToggleView.sub({
    init: function() {
      this.constructor.__super__.init.apply(this, arguments);

      this.progressView = $("#slideInfo")
      $.subscribe("presentation:slide:didChange",$.proxy(this.updateProgress,this));
    },
    progressPercentage: function (slideIndex,slideCount) {
      return Math.ceil(((slideIndex + 1) / slideCount) * 100)
    },
    updateProgress: function(event,slideIndex,slideCount) {
      percent = this.progressPercentage(slideIndex,slideCount);
      this.progressView.text((slideIndex + 1) + '/' + slideCount + '  - ' + percent + '%')
    }
  });

  window.HelpMenu = ToggleView.sub();

  window.PauseScreen = ToggleView.sub();

  window.SpeakerNotes = ToggleView.sub({
    init: function() {
      this.constructor.__super__.init.apply(this, arguments)

      $.subscribe("presentation:slide:didChange",$.proxy(this.updateNotes,this));
    },
    updateNotes: function(event,slide) {
      // Update the text from the slide's notes
    }
  });

  window.DebugView = ToggleView.sub({
    log: function(text) {
      this.element.text(text);
    }
  });


  window.Slide = Spine.Class.create({
    index: 0,
    maxSlides: 0,
    init: function() {
      this.htmlContent = arguments[0];
      this.index = arguments[1];
      this.maxSlides = arguments[2];

      this.transition = this.htmlContent.attr('data-transition');

      this.increments = this.htmlContent.find(".incremental > ul > li");
      this.currentIncrement = 0;

      if (this.increments.size() == 0) {
        this.increments = this.htmlContent.find(".incremental pre pre")
        this.codeIncremental = true;
      }

      this.increments.each(function(index, increment) {
        $(increment).css('visibility', 'hidden');
      });

    },
    currentIncrement: 0,
    increment: function(incrementIndex) {
      var increment = this.increments.eq(incrementIndex);

      if (this.codeIncremental && increment.hasClass('command')) {
        increment.find('.prompt').css('visibility', 'visible');
        increment.find('.input').css('visibility', 'visible').jTypeWriter({duration:1.0});
      } else {
        increment.css('visibility', 'visible');
      }

    },
    nextIncrement: function() {
      this.increment(this.currentIncrement);
      this.trigger("parade:incr");
      this.currentIncrement ++;
    },
    hasIncrement: function() {
      return (this.currentIncrement < this.increments.size());
    },
    showAllIncrements: function() {
      this.increments.each(function(index, increment) {
        $(increment).css('visibility', 'visible');
      });
      this.currentIncrement = this.increments.size();
    },
    isFullPage: function() {
      return this.htmlContent.find(".content").is('.full-page');
    },
    notes: function() {
      return this.htmlContent.find("p.notes").text();
    },
    goFullPage: function() {
      this.htmlContent.css({'width' : '100%', 'text-align' : 'center', 'overflow' : 'visible'});
    },
    trigger: function(eventName) {
      var event = jQuery.Event(eventName);
      this.htmlContent.find(".content").trigger(event,this);
      return event;
    }
  });

  window.Slides = Spine.Class.create({
    init: function() {
      this.element = $("#slides");
      this.slides = $("#slides > .slide");
    },
    show: function() {
      this.element.show()
    },
    hide: function() {
      this.element.hide()
    },
    load: function() {

      // $("#slides img").batchImageLoad({
      //   loadingCompleteCallback: presentation.initialize()
      // });

      // $("#slides").load("/slides",function() {
      //   console.log("loading slides complete");
      //   $("#slides img").batchImageLoad({
      //     loadingCompleteCallback: presentation.initialize()
      //   });
      // });
    },
    size: function() {
      return this.slides.size();
    },
    at: function(index) {
      return new Slide($(this.slides.eq(index)),index,this.size());
    }
  });

  window.NavigationMenu = ToggleView.sub({
    init: function() {
      this.constructor.__super__.init.apply(this,arguments);
      this.menuView = $("#navigation");
    },
    populate: function(slides) {

      var menu = new ListMenu()

      slides.each(function(slideCount, slideElement) {

        // TODO: by default the menu is populated with the html,
        //  allow the user to specify some metadata

        content = $(slideElement).children(".content")
        shortTitle = $(content).text().substr(0, 20)
        path = $(content).attr('ref').split('/')

        menu.addItem(path, shortTitle, slideCount + 1)
      })

      this.menuView.html(menu.getList());

      this.element.menu({
        content: this.menuView.html(),
        flyOut: true,
        width: 200
      });

    },
    toggle: function() {
      this.constructor.__super__.toggle.apply(this,arguments);
      this.open();
    },
    show: function() {
      this.constructor.__super__.show.apply(this,arguments);
      this.open();
    },
    open: function() {
      this.element.trigger('click');
    }
  });


  window.Presentation = Spine.Class.create({
    slides: new Slides(),
    slidenum: 0,
    presentationFrame: $("#preso"),

    footer: new Footer("#footer","presentation:footer"),
    helpMenu: new HelpMenu("#help","help"),
    pauseScreen: new PauseScreen("#pauseScreen","presentation:pause"),
    speakerNotes: new SpeakerNotes("#notesInfo","presentation:speaker:notes"),
    debugView: new DebugView("#debugInfo","debug"),
    navigationMenu: new NavigationMenu("#navmenu","presentation:navigation"),

    init: function() {

    },
    start: function() {
      console.log("Initializing Presentation");

      this.slides.show();

      // TODO: Another entity to center the slides should be put in place
      this.centerSlides();

      // Copy the slides into the presentation area
      this.presentationFrame.empty();
      this.slides.slides.appendTo(this.presentationFrame);

      // Create the jquery cycle in the presentation frame
      this.presentationFrame.cycle({
        timeout: 0
      });

      this.navigationMenu.hide();
      this.navigationMenu.populate(this.slides.slides);

      $.subscribe("presentation:slide:location:change",$.proxy(function(event,slideIndex) {
        this.gotoSlide(slideIndex);
      },this));

      this.showFirstSlide();

      this.presentationFrame.trigger("parade:loaded");

      $.subscribe("presentation:slide:next",$.proxy(function() {
        this.nextStep();
      },this));

      $.subscribe("presentation:slide:previous",$.proxy(function() {
        this.prevStep();
      },this));

      $.subscribe("presentation:reload",$.proxy(function() {
        // this.loadSlides(loadSlidesBool, loadSlidesPrefix)
        this.loadSlides()

        // FIXME: currently the reload is making the slides appear lower
        //   then where they are originally.
        this.slidenum = 0
        this.showSlide()
      },this));

      $.subscribe("presentation:preshow:start",$.proxy(function() {
        this.footer.hide();
      },this));

      $.subscribe("presentation:preshow:stop",$.proxy(function() {
        this.footer.show();

        // Returning from a presentation requires the presentation frame to
        // be rebuilt.

        this.presentationFrame.cycle({
          timeout: 0
        });
        this.showSlide();

      },this));

    },
    centerSlides: function() {
      console.log("Centering Slides");
      var presentation = this;
      this.slides.slides.each(function(s,slide) {
        presentation.centerSlide(slide);
      });
    },
    centerSlide: function(slide) {
      var slideObject = $(slide);
      var slide_content = slideObject.children(".content").first();
      var height = slide_content.height();
      var margin_top = (0.5 * parseFloat(slideObject.height())) - (0.5 * parseFloat(height));
      if (margin_top < 0) {
        margin_top = 0;
      }
      slide_content.css('margin-top', margin_top);
    },
    showFirstSlide: function() {
      this.slidenum = WindowToSlideLocation.location();
      this.updateSlide();
      this.showSlide()
    },
    gotoSlide: function(slideNum) {
     this.slidenum = parseInt(slideNum)
     if (!isNaN(this.slidenum)) {
       this.showSlide()
     }
    },
    slideTotal: function() {
      return this.slides.size();
    },
    nextSlide: function() {
      this.slidenum ++;
      this.updateSlide();
      this.showSlide();
    },
    previousSlide: function() {
      this.slidenum --;
      this.updateSlide();
      this.currentSlide.transition = "none";
      this.currentSlide.showAllIncrements();
      this.showSlide();
    },
    updateSlide: function() {
      this.currentSlide = this.slides.at(this.slidenum);
    },
    showSlide: function() {

      if(this.slidenum < 0) {
        this.slidenum = 0
        return
      }

      var maxSlides = this.slideTotal();

      if(this.slidenum > (maxSlides - 1)) {
        this.slidenum = maxSlides - 1
        return
      }

      var currentSlide = this.currentSlide;

      var transition = currentSlide.transition;
      var slideIsFullPage = currentSlide.isFullPage();

      if (slideIsFullPage) {
        transition = 'none';
      }

      $.publish("presentation:slide:willChange",[ this.slidenum, maxSlides ]);
      this.presentationFrame.cycle(this.slidenum, transition);
      $.publish("presentation:slide:didChange",[ this.slidenum, maxSlides ]);

      if (slideIsFullPage) {
        this.presentationFrame.css({'width' : '100%', 'overflow' : 'visible'});
        currentSlide.goFullPage();
      } else {
        this.presentationFrame.css({'width' : '', 'overflow' : ''});
      }

      WindowToSlideLocation.updateLocation(this.slidenum + 1);

      $.publish('code:execution:clear');

      currentSlide.trigger("parade:show");

      return currentSlide.notes();
    },
    nextStep: function() {

      var triggeredEvent = this.currentSlide.trigger("parade:next");

      if (triggeredEvent.isDefaultPrevented()) {
        return;
      }

      if (this.currentSlide.hasIncrement()) {
        this.currentSlide.nextIncrement();
      } else {
        this.nextSlide();
      }
    },
    prevStep: function() {

     var triggeredEvent = this.currentSlide.trigger("parade:prev");

     if (triggeredEvent.isDefaultPrevented()) {
         return;
     }

     this.previousSlide();
    },
    debug: function(text) {
      this.debugView.log(text);
    }
  });

  window.WindowToSlideLocation = Spine.Class.sub();
  WindowToSlideLocation.location = function() {
    var result;
    if (result = window.location.hash.match(/#([0-9]+)/)) {
      return result[result.length - 1] - 1;
    } else {
      return 0;
    }
  }
  WindowToSlideLocation.updateLocation = function(newLocation) {
    window.location.hash = newLocation;
  }

  window.LocationWatcher =  Spine.Class.create({
    init: function() {
      var presentation = this;
      this.watchEnabled = false;
      this.lastResult = this.windowLocation();

      $.subscribe("presentation:slide:didChange",$.proxy(function(event,slideCount,maxSlides) {
        this.lastResult = slideCount;
      },this));

    },
    start: function() {
      if (this.watchEnabled === false) {
        this.watchEnabled = true;
        this.perform();
      }
    },
    stop: function() {
      this.watchEnabled = false;
    },
    perform: function() {
      var currentResult = this.windowLocation();
      if (this.lastResult != currentResult) {
        $.publish("presentation:slide:location:change",currentResult);
      }

      this.lastResult = currentResult;

      if (this.watchEnabled) {
        setTimeout($.proxy(this.perform,this), 200);
      }
    },
    windowLocation: function() {
      return WindowToSlideLocation.location();
    }
  });


});

$(document).ready(function() {
  presentation = new Presentation;
  presentation.start();

  var locationWatcher = new LocationWatcher();
  locationWatcher.start();

  preshow = new Preshow("#preso",0.25);

  // bind event handlers
  /* window.onresize  = resized; */
  /* window.onscroll = scrolled; */
  /* window.onunload = unloaded; */

  $('buttonNav.prev').click(function(){
    $.publish("presentation:slide:previous");
  });

  $('buttonNav.next').click(function(){
    $.publish("presentation:slide:next");
  });

});
