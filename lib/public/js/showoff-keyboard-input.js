//
// Register all the keyboard inputs for ShowOff presentation events.
//

$(document).ready(function() {

  KeyboardJS.on('space, right, pagedown, down', function(){
    $.publish("presentation:slide:next");
  });

  KeyboardJS.on('shift + space, left, pageup, up', function(){
    $.publish("presentation:slide:previous");
  });

  // KeyboardJS.on('t, c', function(){
  //   $.publish("presentation:navigation:toggle");
  // });
  // 
  // KeyboardJS.on('z, ?', function(){
  //   $.publish("help:toggle");
  // });
  // 
  // KeyboardJS.on('b, f', function(){
  //   $.publish("presentation:footer:toggle");
  // });
  // 
  // KeyboardJS.on('d', function(){
  //   $.publish("debug:toggle");
  // });
  // 
  // KeyboardJS.on('n', function(){
  //   $.publish("presentation:speaker:notes:toggle");
  // });
  // 
  // KeyboardJS.on('p', function(){
  //   $.publish("presentation:pause:toggle");
  // });
  // 
  // KeyboardJS.on('shift + p', function(){
  //   $.publish("presentation:preshow:toggle");
  // });

  // 0 - 9
   // if (key >= 48 && key <= 57){
   //   console.log("goto slide: " + (key - 48))
   //
   //   // TODO: this does not work for multiple number entries, so I am disabling
   //   //  it from executing.
   //   // gotoSlidenum = gotoSlidenum * 10 + (key - 48);
   //   return true;
   // }
});