/*!
 * jQuery Tiny Pub/Sub - v0.3 - 11/4/2010
 * http://benalman.com/
 *
 * Copyright (c) 2010 "Cowboy" Ben Alman
 * Dual licensed under the MIT and GPL licenses.
 * http://benalman.com/about/license/
 */

(function($){

  var o = $({});

  $.subscribe = function() {
    o.bind.apply( o, arguments );
  };

  $.unsubscribe = function() {
    o.unbind.apply( o, arguments );
  };

  $.publish = function() {
    console.log("Publish: " + arguments[0]);
    o.trigger.apply( o, arguments );
  };

})(jQuery);



function executeAnyCode() {
  var $jsCode = $('.execute .sh_javascript pre:visible')
  if ($jsCode.length > 0) {
      executeCode.call($jsCode);
  }
  var $rubyCode = $('.execute .sh_ruby pre:visible')
  if ($rubyCode.length > 0) {
      executeRuby.call($rubyCode);
  }
  var $coffeeCode = $('.execute .sh_coffeescript pre:visible')
  if ($coffeeCode.length > 0) {
      executeCoffee.call($coffeeCode);
  }
}

function swipeLeft() {
  nextStep();
}

function swipeRight() {
  prevStep();
}

function ListMenu(s)
{
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

function ListMenuItem(t, s)
{
  this.typeName = "ListMenuItem"
  this.slide = s
  this.textName = t
}

var removeResults = function() {
  $('.results').remove();
};

var print = function(text) {
  removeResults();
  var _results = $('<div>').addClass('results').html($.print(text, {max_string:500}));
  $('body').append(_results);
  _results.click(removeResults);
};

function executeCode () {
  result = null;
  var codeDiv = $(this);
  codeDiv.addClass("executing");
  eval(codeDiv.text());
  setTimeout(function() { codeDiv.removeClass("executing");}, 250 );
  if (result != null) print(result);
}
$('.execute .sh_javascript pre').live("click", executeCode);

function executeRuby () {
  var codeDiv = $(this);
  codeDiv.addClass("executing");
    $.get('/eval_ruby', {code: codeDiv.text()}, function(result) {
        if (result != null) print(result);
        codeDiv.removeClass("executing");
    });
}
$('.execute .sh_ruby pre').live("click", executeRuby);

function executeCoffee() {
  result = null;
  var codeDiv = $(this);
  codeDiv.addClass("executing");
  // Coffeescript encapsulates everything, so result must be attached to window.
  var code = codeDiv.text() + ';window.result=result;'
  eval(CoffeeScript.compile(code));
  setTimeout(function() { codeDiv.removeClass("executing");}, 250 );
  if (result != null) print(result);
}
$('.execute .sh_coffeescript pre').live("click", executeCoffee);

/********************
 PreShow Code
 ********************/

var preshow_seconds = 0;
var preshow_secondsLeft = 0;
var preshow_secondsPer = 8;
var preshow_running = false;
var preshow_timerRunning = false;
var preshow_current = 0;
var preshow_images;
var preshow_imagesTotal = 0;
var preshow_des = null;

function togglePreShow() {
  if(preshow_running) {
    stopPreShow()
  } else {
    var minutes = prompt("Minutes from now to start")
    preshow_secondsLeft = parseFloat(minutes) * 60

    $.getJSON("preshow", false, function(data) {
      $('#preso').after("<div id='preshow'></div><div id='tips'></div><div id='preshow_timer'></div>")
      $.each(data, function(i, n) {
        if(n == "preshow.json") {
          // has a descriptions file
          $.getJSON("/file/preshow/preshow.json", false, function(data) {
            preshow_des = data
          })
        } else {
          $('#preshow').append('<img ref="' + n + '" src="/file/preshow/' + n + '"/>')
        }
      })
      startPreShow()
    })
  }
}

function startPreShow() {

  $.publish("presentation:preshow:start");

  if (!preshow_running) {
    preshow_running = true
    preshow_seconds = 0
    preshow_images = $('#preshow > img')
    preshow_imagesTotal = preshow_images.size()
    nextPreShowImage()

    if(!preshow_timerRunning) {
      setInterval(function() {
        preshow_timerRunning = true
        if (!preshow_running) { return }
        preshow_seconds++
        preshow_secondsLeft--
    if (preshow_secondsLeft < 0) {
      stopPreShow()
    }
        if (preshow_seconds == preshow_secondsPer) {
          preshow_seconds = 0
          nextPreShowImage()
        }
    addPreShowTips()
      }, 1000)
    }
  }
}

function addPreShowTips() {
  time = secondsToTime(preshow_secondsLeft)
  $('#preshow_timer').text(time + ' to go-time')
  var des = preshow_des && preshow_des[tmpImg.attr("ref")]
  if(des) {
    $('#tips').show()
    $('#tips').text(des)
  } else {
    $('#tips').hide()
  }
}

function secondsToTime(sec) {
  min = Math.floor(sec / 60)
  sec = sec - (min * 60)
  if(sec < 10) {
    sec = "0" + sec
  }
  return min + ":" + sec
}

function stopPreShow() {
  preshow_running = false

  $('#preshow').remove()
  $('#tips').remove()
  $('#preshow_timer').remove()

  $.publish("presentation:preshow:stop");
}

function nextPreShowImage() {
  preshow_current += 1
  if((preshow_current + 1) > preshow_imagesTotal) {
    preshow_current = 0
  }

  $("#preso").empty()
  tmpImg = preshow_images.eq(preshow_current).clone()
  $(tmpImg).attr('width', '1020')
  $("#preso").html(tmpImg)
}

/********************
 End PreShow Code
 ********************/

$(document).ready(function() {

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
    init: function() {
      this.htmlContent = arguments[0];
      this.index = arguments[1];

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
    increment: function(incrementIndex) {
      console.log("Showing increment: " + incrementIndex);

      var increment = this.increments.eq(incrementIndex);

      if (this.codeIncremental && increment.hasClass('command')) {
        increment.css('visibility', 'visible').jTypeWriter({duration:1.0});
      } else {
        increment.css('visibility', 'visible');
      }

    },
    nextIncrement: function() {
      this.increment(this.currentIncrement);
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
      this.htmlContent.find(".content").trigger(event);
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
      console.log("Slides loaded");
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
      return new Slide($(this.slides.eq(index)));
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
      console.log("Initializing Preso");

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


      this.presentationFrame.trigger("showoff:loaded");

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
        this.loadSlides();
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
    getCurrentNotes: function() {
      var notes = this.currentSlide.notes();
      $('#notesInfo').text(notes);
      return notes;
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
      var fullPage = currentSlide.isFullPage();

      if (fullPage) {
        transition = 'none';
      }

      $.publish("presentation:slide:willChange",[ this.slidenum, maxSlides ]);
      this.presentationFrame.cycle(this.slidenum, transition);
      $.publish("presentation:slide:didChange",[ this.slidenum, maxSlides ]);

      if (fullPage) {
        this.presentationFrame.css({'width' : '100%', 'overflow' : 'visible'});
        currentSlide.goFullPage();
      } else {
        this.presentationFrame.css({'width' : '', 'overflow' : ''});
      }

      WindowToSlideLocation.updateLocation(this.slidenum + 1);

      // TODO: this is the next thing that I need to re-factor
      removeResults();

      currentSlide.trigger("showoff:show");

       // If we have a presenterView attribute, that means this window was
       // opened by a presenter view, and we should poke it to make
       // it be on the same slide as us and show the correct notes.
             //
             // TODO: we do this in such a hacky way to avoid ever
             // assigning to the presenterView variable here. If we do
             // that, we can clobber the value sent in by the parent
             // presentation view and break the feature. Is there a better
             // way to do this?
       // if ('presenterView' in window) {
       //               var pv = window.presenterView;
       //   pv.slidenum = slidenum;
       //   pv.showSlide(true);
       //   pv.postSlide();
       // }
       return currentSlide.notes();
    },
    nextStep: function() {

      var triggeredEvent = this.currentSlide.trigger("showoff:next");

      if (triggeredEvent.isDefaultPrevented()) {
        return;
      }

      if (this.currentSlide.hasIncrement()) {
        this.currentSlide.nextIncrement();
        // this.showIncremental(this.incrCurr);
        // var incrEvent = jQuery.Event("showoff:incr");
        // incrEvent.slidenum = this.slidenum;
        // incrEvent.incr = this.incrCurr;
        this.currentSlide.trigger("showoff:incr");
        // this.incrCurr++;
      } else {
        this.nextSlide();
      }
    },
    prevStep: function() {

     var triggeredEvent = this.currentSlide.trigger("showoff:prev");

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

  window.DefaultKeyHandler = Spine.Class.create();

  DefaultKeyHandler.include({
    gotoSlidenum: 0,
    debug: function(text) {
      console.log("DEBUGGING: " + text);
    },
    //  See http://www.quirksmode.org/js/keys.html for keycodes
    keyDown: function(event) {
      var key = event.keyCode;

      if (event.ctrlKey || event.altKey || event.metaKey)
        return true;

      // 0 - 9
      if (key >= 48 && key <= 57){
        console.log("goto slide: " + (key - 48))

        // TODO: this does not work for multiple number entries, so I am disabling
        //  it from executing.
        // gotoSlidenum = gotoSlidenum * 10 + (key - 48);
        return true;
      }

      if (key == 13) {
        executeAnyCode();
      }

      // space bar
      if (key == 32) {
        if (event.shiftKey) {
          $.publish("presentation:slide:previous");
        } else {
          $.publish("presentation:slide:next");
        }
      }
      else if (key == 68) // 'd' for debug
      {
        $.publish("debug:toggle");
      }
      else if (key == 37 || key == 33 || key == 38) // Left arrow, page up, or up arrow
      {
        $.publish("presentation:slide:previous");
      }
      else if (key == 39 || key == 34 || key == 40) // Right arrow, page down, or down arrow
      {
        $.publish("presentation:slide:next");
      }
      else if (key == 82) // R for reload
      {
        if (confirm('really reload slides?')) {
          $.publish("presentation:reload");
        }
      }
      else if (key == 84 || key == 67)  // T or C for table of contents
      {
        $.publish("presentation:navigation:toggle");
      }
      else if (key == 90 || key == 191) // z or ? for help
      {
        $.publish("help:toggle");
      }
      else if (key == 66 || key == 70) // f for footer (also "b" which is what kensington remote "stop" button sends
      {
        $.publish("presentation:footer:toggle");
      }
      else if (key == 78) // 'n' for notes
      {
        $.publish("presentation:speaker:notes:toggle");
      }
      else if (key == 27) // esc
      {
        $.publish("presentation:code:clear");
        removeResults();
      }
      else if (key == 80) // 'p' for preshow
      {
        if (event.shiftKey) {
          $.publish("presentation:pause:toggle");
        } else {
          $.publish("presentation:preshow:toggle");
          togglePreShow();
        }
      }
      return true
    },

    keyUp: function(event) {
      var key = event.keyCode;
    }
  });
});

$(document).ready(function() {
  presentation = new Presentation;
  presentation.start();

  presentationController = new DefaultKeyHandler;

  var locationWatcher = new LocationWatcher();
  locationWatcher.start();

  // bind event handlers
  document.onkeydown = presentationController.keyDown;
  document.onkeyup = presentationController.keyUp;
  /* window.onresize  = resized; */
  /* window.onscroll = scrolled; */
  /* window.onunload = unloaded; */

  $('body').addSwipeEvents().
    bind('tap', swipeLeft).         // next
    bind('swipeleft', swipeLeft).   // next
    bind('swiperight', swipeRight); // prev

  $('buttonNav.prev').click(function(){
    $.publish("presentation:slide:previous");
  });


  $('buttonNav.next').click(function(){
    $.publish("presentation:slide:next");
  });

});
