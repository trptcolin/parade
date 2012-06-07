/* ShowOff JS Logic */

var ShowOff = {};

var preso_started = false
var slidenum = 0
var slideTotal = 0
var slides
var currentSlide
var totalslides = 0
var slidesLoaded = false
var incrSteps = 0
var incrElem
var incrCurr = 0
var incrCode = false
var debugMode = false
var gotoSlidenum = 0
var shiftKeyActive = false

var loadSlidesBool
var loadSlidesPrefix


function doDebugStuff()
{
 if (debugMode) {
   $('#debugInfo').show()
   debug('debug mode on')
 } else {
   $('#debugInfo').hide()
 }
}
// 
var notesMode = false
function toggleNotes()
{
  notesMode = !notesMode
	if (notesMode) {
		$('#notesInfo').show()
		debug('notes mode on')
	} else {
		$('#notesInfo').hide()
	}
}

function executeAnyCode()
{
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

function debug(data)
{
	$('#debugInfo').text(data)
}

//  See e.g. http://www.quirksmode.org/js/keys.html for keycodes
function keyDown(event)
{
	var key = event.keyCode;

	if (event.ctrlKey || event.altKey || event.metaKey)
		return true;

	debug('keyDown: ' + key)

	if (key >= 48 && key <= 57) // 0 - 9
	{
		gotoSlidenum = gotoSlidenum * 10 + (key - 48);
		return true;
	}

	if (key == 13) {
		if (gotoSlidenum > 0) {
			debug('go to ' + gotoSlidenum);
			slidenum = gotoSlidenum - 1;
			showSlide(true);
			gotoSlidenum = 0;
		} else {
			debug('executeCode');
			executeAnyCode();
		}
	}


	if (key == 16) // shift key
	{
		shiftKeyActive = true;
	}

	if (key == 32) // space bar
	{
		if (shiftKeyActive) {
			prevStep()
		} else {
			nextStep()
		}
	}
	else if (key == 68) // 'd' for debug
	{
		debugMode = !debugMode
		doDebugStuff()
	}
	else if (key == 37 || key == 33 || key == 38) // Left arrow, page up, or up arrow
	{
		prevStep()
	}
	else if (key == 39 || key == 34 || key == 40) // Right arrow, page down, or down arrow
	{
		nextStep()
	}
	else if (key == 82) // R for reload
	{
		if (confirm('really reload slides?')) {
			loadSlides(loadSlidesBool, loadSlidesPrefix)
			showSlide()
		}
	}
	else if (key == 84 || key == 67)  // T or C for table of contents
	{
		$('#navmenu').toggle().trigger('click')
	}
	else if (key == 90 || key == 191) // z or ? for help
	{
		$('#help').toggle()
	}
	else if (key == 66 || key == 70) // f for footer (also "b" which is what kensington remote "stop" button sends
	{
		toggleFooter()
	}
	else if (key == 78) // 'n' for notes
	{
		toggleNotes()
	}
	else if (key == 27) // esc
	{
		removeResults();
	}
	else if (key == 80) // 'p' for preshow
	{
	  debugger
	  if (shiftKeyActive) {
	    togglePause();
	  } else {
		  togglePreShow();
	  }
	}
	return true
}

function toggleFooter()
{
	$('#footer').toggle()
}

function keyUp(event) {
	var key = event.keyCode;
	debug('keyUp: ' + key);
	if (key == 16) // shift key
	{
		shiftKeyActive = false;
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
		toggleFooter()
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

	toggleFooter()
	loadSlides(loadSlidesBool, loadSlidesPrefix);
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

function togglePause() {
  $("#pauseScreen").toggle();
}
