$(document).ready(function() {

  var publishCommand = function(notificationName) {
    return function(tokens) { $.publish(notificationName); };
  }

  window.TerminalCommands = {
    next : publishCommand('presentation:slide:next'),
    previous : publishCommand('presentation:slide:previous'),
    goto : function(tokens) {
      var slide = parseInt(tokens[0]) - 1;
      $.publish('presentation:slide:location:change',slide);
    }
   };

});