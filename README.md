# ShowOff Presentation Software

ShowOff is a Sinatra web app that reads serves up markdown files in a
presentation format. Showoff can serve a directory or be configured to run with
a simple configuration file.

## Comparison Vs PowerPoint / Keynote

Showoff is easily out-done by professional presentation software packages as
far as out-of-the-box style and design. However, there are benefits that
ShowOff has over presentational software:

### The Good

* Markdown backed data

    > This ultimately makes it easier to manage diffs when making changes,
    using the content in other documents, and quickly re-using portions of a
    presentation.

* Syntax Highlighting

    > Using github flavored markdown, code fences will automatically be
    syntax highlighted making it incredibly easy to integrate code samples

* Code Execution

    > Slides are able to provide execution and show results for javascript,
    Coffeescript, and Ruby live within the browser. Allowing for live
    demonstrations of code.

* Web

    > The system is simply a website which allows for a lot of possibilities

### The Ugly

* Lack of style

    > Most presentation packages are going to provide for you better templates

* Speed of Layout and Animation

    > Unless you're skills are great with CSS/Animations, you are likely going
    to have a harder time creating presentations with as much polish.

* Resizing

    > Currently the presentation system can change gradual sizes, but is not
    very capable of growing well to the full resolution of current presentation
    resolution.

## Comparison Vs [schacon's ShowOff](https://github.com/schacon/showoff)

This is a fork of that project and includes my attempts to remedy some design
gaps with regards to the implementation.

### The Good

* Modular Design

    > The work here is the initial teasing out concepts and classes form the
    original implementation that left most of the logic within the core
    Sinatra application object.

* Github Flavored Markdown

    > Syntax Highlighting through code fences instead of the strange
    additional construct of using `@@@ LANGUAGE` within the code samples.
    Essentially your markdown can now adhere to more accepted markdown
    standards.

* Showoff File Format

    > I replaced the existing *showoff.json* with *showoff* and implemented
    a DSL to provide current support and the ability to perform future features.

### The Bad

* Showoff File Format

    > Replacing *showoff.json* with *showoff* breaks support with all existing
    showoff presentations.


* Onepage

    > Currently this is crashing when I am using this feature. However, I never
    required this feature so I have not been concerned with fixing it in the
    work that I have done.

* Static

    > This is likely crashing as well. Again it is a feature I was not using
    so I have not been concerned with fixing it.

* Command-Line Utilities

    > I have never used them to generate a presentation so I may have likely
    broken some of that functionality.

### The Ugly

* PDF Support

    > PDF support was never great to begin with when you started to use custom
    stylesheets and now it's likely worse then before when even using the
    standard styles. This is a lower priority issue for me at the moment.


# Installation and Usage

```bash
$ gem install showoff
```

## `showoff serve`

By default running `serve` with start a presentation from the current working
directory. It will find all markdown files, `**/*.md`, within the directory
and create a presentation out of them.

>  By default showoff will create split slides along markdown `#`

You can manage the presentation with the following keys:

* `space`, `cursor right`

    > Advance to the next slide or advance the next incremental bullet point
    or show the end result of the code execution.

* `shift-space`, `cursor left`

    > Move to the previous slide

* `d`

    > Toggle DEBUG information

* `c`, `t`

    > Toggle the display of the Table of Contents

* `f`

    > Toggle footer (which shows slide count of total slides, percentage)

* `z`, `?`

    > Toggle help


* `p`

    > Toggle pre-show


### Serving a specific directory

```bash
$ showoff serve DIRECTORY
```

This will start a presentation from the specified directory. Again, finding all
markdown files contained within the directories or sub-directories.

### Serving specific files

To include certain files, specify an order, duplicate slides, you will need to
define a `showoff` file. Within that file, you may define specific files,
specific folders, and the order of the presentation.

```ruby

title "My Presentation"

section "intro.md"

# `content` in this case is  directory
```

# Slide Format

## Slide Separators

### Separator: `#`

Slides are simply markdown format. As stated previously, slides will be
separated along the `#`elements within your document.

### Separator: `!SLIDE`

Relying on the `#` as a separator is not always ideal. So you may alternatively
use the `!SLIDE` separator. This also provides you with the ability to define
additional metadata with your slides and presentation.

```markdown
!SLIDE

# My Presentation #

!SLIDE bullets incremental transition=fade

# Bullet Points #

* first point
* second point
* third point
```

> Using this separator will immediately override `#`, so you will have to
  insert `!SLIDE` separators in all places you would like cut your slides.

## Notes

You can define special notes that are shown in presenter mode.

Add a line that starts with .notes:

```markdown
## Important Slide

* First Thing
* Second Things

.notes The reason that the second thing came about is because things changed.
```

> In this example, the HTML output will contain a `<p class='notes'>`
Toggle presenter notes with the n key while in the presentation.


### Metadata

#### HTML IDs

```markdown
!SLIDE #slide-id-1
```

> In this example the id of the slide div would be set to `#slide-id-1`

You can define an ID that will be added to the slide's `div`. This id will be
set to any value prefaced with the `#` character.

#### Transitions

```markdown
!SLIDE transition=fade
```

> In this example, the slide will __fade__ when it is viewed. This will set
  `data-transition='fade'` on the slides's `div`.

You can define transitions from the available body of transitions.

The transitions are provided by jQuery Cycle plugin. See http://www.malsup.com/jquery/cycle/browser.html to view the effects and http://www.malsup.com/jquery/cycle/adv2.html for how to add custom effects.

##### Available Transitions

* none (this is the default)
* blindX, blindY, blindZ
* cover
* curtainX, curtainY
* fade
* fadeZoom
* growX, growY
* scrollUp, scrollDown, scrollLeft, scrollRight
* scrollHorz, scrollVert
* shuffle
* slideX, slideY
* toss
* turnUp, turnDown, turnLeft, turnRight
* uncover
* wipe
* zoom

#### CSS Classes

```markdown
!SLIDE bullets incremental my-custom-css-class
```
> In this example, this will add custom css classes to the slide's `div` will
  display the following classes:
  `class='content bullets incremental my-custom-css-class'`. _Note:_ the content
  class is added by the default slide template.

All remaining single terms are added as css classes to the slide's `div`.

##### Defined Classes

ShowOff defines a number of special CSS classes:

* center
    > centers images on a slide

* full-page
    > allows an image to take up the whole slide

* bullets
    > sizes and separates bullets properly (fits up to 5, generally)

* smbullets
    > sizes and separates more bullets (smaller, closer together)

* subsection
    > creates a different background for titles

* command
    > monospaces h1 title slides

* commandline
    > for pasted commandline sections (needs leading '$' for commands, then
      output on subsequent lines)

* code
    > monospaces everything on the slide

* incremental
    > can be used with 'bullets' and 'commandline' styles, will incrementally
      update elements on arrow key rather than switch slides

* small
    > make all slide text 80%

* smaller
    > make all slide text 70%
* execute
    > on Javascript, Coffeescript and Ruby highlighted code slides, you can
      click on the code to execute it and display the results on the slide


# Presentation Customization

## Custom JavaScript

To insert custom JavaScript into your presentation you can either place it into
a file (with extension .js) into the root directory of your presentation or you
can embed a <script> element directly into your slides. This JavaScript will
be executed—as usually—as soon as it is loaded.

If you want to trigger some JavaScript as soon as a certain page is shown or
when you switch to the next or previous slide, you can bind a callback to a
custom event:

* *showoff:show* will be triggered as soon as you enter a page
* *showoff:next* will be triggered when you switch to the next page
* *showoff:incr* will be triggered when you advance to the next increment on the page
* *showoff:prev* will be triggered when you switch to the previous page

These events are triggered on the "div.content" child of the slide, so you must
add a custom and unique class to your SLIDE to identify it:

    !SLIDE custom_and_unique_class
    # 1st Example h1
    <script>
    // bind to custom event
    $(".custom_and_unique_class").bind("showoff:show", function (event) {
      // animate the h1
      var h1 = $(event.target).find("h1");
      h1.delay(500)
        .slideUp(300, function () { $(this).css({textDecoration: "line-through"}); })
        .slideDown(300);
    });
    </script>

This will bind an event handler for *showoff:show* to your slide. The
h1-element will be animated, as soon as this event is triggered on that slide.

If you bind an event handler to the custom events *showoff:next* or
*showoff:prev*, you can prevent the default action (that is switching to the
appropriate slide) by calling *event.preventDefault()*:

    !SLIDE prevent_default
    # 2nd Example h1
    <script>
    $(".prevent_default").bind("showoff:next", function (event) {
      var h1 = $(event.target).find("h1");
      if (h1.css("text-decoration") === "none") {
        event.preventDefault();
        h1.css({textDecoration: "line-through"})
      }
    });
    </script>

This will bind an event handler for *showoff:next* to your slide. When you press
the right arrow key the first time, the h1-element will be decorated. When you
press the right array key another time, you will switch to the next slide.

The same applies to the *showoff:prev* event, of course.

## Custom Stylesheets

To insert custom Stylesheets into your presentation you can either place it into
a file (with extension .css) into the root directory of your presentation or
you can embed a <link> element directly into your slides. This stylesheet will
be applied as soon as it is loaded.

The content generated by the slide is wrapped with a +div+ with the class .+content+ like this.

    <div ref="intro/01_slide/1" class="content" style="margin-top: 210px;">
    <h1>jQuery &amp; Sinatra</h1>
    <h2>A Classy Combination</h2>
    </div>

This makes the .+content+ tag a perfect place to add additional styling if that
is your preference. An example of adding some styling is here.

    .content {
      color: black;
      font-family: helvetica, arial;
    }
    h1, h2 {
      color: rgb(79, 180, 226);
      font-family: Georgia;
    }
    .content::after {
      position: absolute;
      right: 120px;
      bottom: 120px;
      content: url(jay_small.png);
    }

Note that the example above uses CSS3 styling with ::+after+ and the +content+
-attribute to add an image to the slides.

## Custom Ruby Files

If you want to have executable Ruby code on your slides you must set the
environment variable ENV['SHOWOFF_EVAL_RUBY']. This can be done with

    export SHOWOFF_EVAL_RUBY=1

or

    # On Heroku
    heroku config:add SHOWOFF_EVAL_RUBY=1


If you need supporting libraries when you evaluate the code. You can do this by
putting Ruby files (*.rb) into the root directory of the presentation then they
will be required when the presentation loads.

# Command Line Interface

```bash
showoff command_name [command-specific options] [--] arguments...
```

* Use the command +help+ to get a summary of commands
* Use the command `help command_name` to get a help for +command_name+
* Use `--` to stop command line argument processing; useful if your arguments have dashes in them

## Commands
[`add`] Add a new slide at the end in a given dir
[`create`] Create new showoff presentation
[`help`] Shows list of commands or help for one command
[`heroku`] Setup your presentation to serve on Heroku
[`github`] Setup your presentation to serve on GitHub Pages
[`serve`] Serves the showoff presentation in the current directory (or a given dir)
[`static`] Generate static version of presentation


## `showoff add [title]`

Add a new slide at the end in a given dir

*Aliases*
* `<b>new</b>`

Outputs or creates a new slide. With -d and -n, a new slide is created in the given dir, numbered to appear
as the last slide in that dir (use -u to avoid numbering). Without those, outputs the slide markdown to
stdout (useful for shelling out from your editor). You may also specify a source file to use for a code
slide.

### options for add

These options are specified *after* the command.

[`-d, --dir=dir`] Slide dir (where to put a new slide file)
[`-n, --name=basename`] Slide name (name of the new slide file)
[`-s, --source=path to file`] Include code from the given file as the slide body
[`-t, --style, --type=valid showoff style/type`] Slide Type/Style <i>( default: `title`)</i>
[`-u, --nonumber`] Dont number the slide, use the given name verbatim


## `showoff create dir_name`

Create new showoff presentation

*Aliases*
* `<b>init</b>`

This command helps start a new showoff presentation by setting up the proper directory structure for you.  It takes the directory name you would like showoff to create for you.

### options for create

These options are specified *after* the command.

[`-d, --slidedir=arg`] sample slide directory name <i>( default: `one`)</i>
[`-n, --nosamples`] Dont create sample slides


## `showoff help [command]`

Shows list of commands or help for one command


## `showoff heroku heroku_name`

Setup your presentation to serve on Heroku

Creates the Gemfile and config.ru file needed to push a showoff pres to heroku.  It will then run heroku create for you to register the new project on heroku and add the remote for you.  Then all you need to do is commit the new created files and run git push heroku to deploy.


## `showoff github`

Generates a static version of your site and puts it in a gh-pages branch for static serving on GitHub.

### options for github
These options are specified *after* the command.

[`-f, --force`] force overwrite of existing Gemfile/.gems and config.ru files if they exist
[`-g, --dotgems`] Use older-style .gems file instead of bundler-style Gemfile
[`-p, --password=arg`] add password protection to your heroku site


## `showoff serve `

Serves the showoff presentation in the current directory

### options for serve
These options are specified *after* the command.

[`-f, --pres_file=arg`] Presentation file <i>(default: `showoff`)</i>
[`-h, --host=arg`] Host or ip to run on <i>( default: `localhost`)</i>
[`-p, --port=arg`] Port on which to run <i>( default: `9090`)</i>


## `showoff static name`

Generate static version of presentation

# PDF Output

Showoff can produce a PDF version of your presentation.  To do this, you must install a few things first:

    gem install pdfkit

You'll then need to install a version of wkhtmltopdf available at the {wkhtmltopdf repo}[http://code.google.com/p/wkhtmltopdf/wiki/compilation] (or brew install wkhtmltopdf on a mac) and make sure that +wkhtmltopdf+ is in your path:

    export $PATH="/location/to/my/wkhtmltopdf/0.9.9:$PATH"

Then restart showoff, and navigate to `/pdf` (e.g. http://localhost/pdf) of your presentation and a PDF will be generated with the browser.


# External Tools

## ZSH completion
You can complete commands and options in ZSH, by installing a script:

    mkdir -p $HOME/.zsh/Completion
    cp script/_showoff $HOME/.zsh/Completion
    echo 'fpath=(~/.zsh/Completion $fpath)' >> $HOME/.zshrc

## `bash` completion

You can complete commands for showoff by putting the following in your `.bashrc` (or whatever
you use when starting `bash`):

    complete -F get_showoff_commands
    function get_showoff_commands()
    {
        if [ -z $2 ] ; then
            COMPREPLY=(`showoff help -c`)
        else
            COMPREPLY=(`showoff help -c $2`)
        fi
    }


## Editor Support

* TextMate Bundle - Showoff.tmdbundle - Dr Nic Williams
  http://github.com/drnic/Showoff.tmbundle

* Emacs major-mode - showoff-mode - Nick Parker
  http://github.com/developernotes/showoff-mode

# Future Plans

I really want this to evolve into a dynamic presentation software server,
that gives the audience a lot of interaction into the presentation -
helping them decide dynamically what the content of the presentation is,
ask questions without interrupting the presenter, etc.  I want the audience
to be able to download a dynamically generated PDF of either the actual
talk that was given, or all the available slides, plus supplementary
material. And I want the presenter (me) to be able to push each
presentation to Heroku or GitHub pages for archiving super easily.

- pdf with notes
- presenter view
  - timer (time left, percent done, percent time done)
- editing slides
- webpage
- clean up js
- clean up ruby
- showoff add
  - add slides of images directory (refactor script/import_images.rb)
- simple highlighting (highlight region of slide / click to highlight)
- presenter tools
  - preview column
  - preview
- audience interface
  - slide download / git clone
  - static version download
  - questions / comments system
  - audience vote-based presentation builder, results live view
- simple animations (image from A to B)
- squeeze-to-fit style
- extract Version into a separate file, so we can include it in gemspec without pulling in the universe
* show a timer - elapsed / remaining
* perform simple animations of images moving between keyframes
* show synchronized, hidden notes on another browser (like an iphone)
* show audience questions / comments (twitter or direct)
* let audience members go back / catch up as you talk
* let audience members vote on sections (?)
* broadcast itself on Bonjour
* let audience members download slides, code samples or other supplementary material
* let you write on the slide with your mouse, madden-style via canvas
* automatically resize text to fit screen [see Alex's shrink.js]
