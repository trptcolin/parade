!SLIDE columns

# Custom events

## Appearance

* parade:willAppear

> triggered before the slide is presented

* parade:didAppear

> triggered after the slide is presented

* parade:show

> triggered after the slide is presented

## Disappearance

* parade:willDisappear

> triggered before the slide disappears

* parade:didDisappear

> triggered after the slide disppeared

## Navigation

* parade:next

> triggered when an attempt to move to the next slide or incremental bullet point

* parade:prev

> triggered when an attempt to move back a slide or incremental bullet point

!SLIDE custom_and_unique_class
# Strikethrough
<script>
// bind to custom event
$(".custom_and_unique_class").live("parade:show", function (event) {
  console.log("Performing show");
  // animate the h1
  var h1 = $(event.target).find("h1");
  
  if (h1.css("text-decoration") === "none") {
    h1.delay(500)
      .slideUp(300, function () { $(this).css({textDecoration: "line-through"}); })
      .slideDown(300);
  }
    return false;
});
</script>

!SLIDE prevent_default
# Strikethrough Before Moving Through
<script>
$(".prevent_default").live("parade:next", function (event) {
  var h1 = $(event.target).find("h1");
  if (h1.css("text-decoration") === "none") {
    h1.css({textDecoration: "line-through"})
    return false;
  }
});
</script>

