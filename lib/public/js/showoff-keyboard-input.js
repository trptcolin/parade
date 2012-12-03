//
// Register all the keyboard inputs for ShowOff presentation events.
//

$(document).ready(function() {

  $.subscribe("console:show",function() {
    KeyboardJS.disable();
  });
  $.subscribe("console:hidden",function() {
    KeyboardJS.enable();
  });

  KeyboardJS.on('space, right, pagedown, down', function(){
    $.publish("presentation:slide:next");
  });

  KeyboardJS.on('shift + space, left, pageup, up', function(){
    $.publish("presentation:slide:previous");
  });

  KeyboardJS.on('h, ?', function(){
    $.publish("help:toggle");
  });

  KeyboardJS.on('b, f', function(){
    $.publish("presentation:footer:toggle");
  });

  KeyboardJS.on('d', function(){
    $.publish("debug:toggle");
  });

  KeyboardJS.on('n', function(){
    $.publish("presentation:speaker:notes:toggle");
  });

  KeyboardJS.on('p', function(){
    $.publish("presentation:pause:toggle");
  });

  KeyboardJS.on('shift + p', function(){
    $.publish("presentation:preshow:toggle");
  });

});