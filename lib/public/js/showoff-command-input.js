$(document).ready(function() {

  var TerminalCommands = {
    next : function(tokens) {
      $.publish('presentation:slide:next');
    },
    previous : function(tokens) {
      $.publish('presentation:slide:previous');
    },
    goto : function(tokens) {
      console.log(tokens);
      var slide = parseInt(tokens[0]) - 1;
      $.publish('presentation:slide:location:change',slide);
    }
   };

  $('#tilda').tilda(function(command, terminal) {

    var tokens = command.split(' ');
    var name = tokens[0];
    var params = tokens.slice(1,tokens.length);

    var commandMappedToName = TerminalCommands[name];

    if (commandMappedToName) {
      commandMappedToName(params);
    } else {
      terminal.echo('Unknown command `' + name + '`');
    }
  });

});