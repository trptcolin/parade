!SLIDE subsection

# Custom events

> ### showoff:show
> will be triggered as soon as you enter a page
> ### showoff:next
> will be triggered when you switch to the next page
> ### showoff:incr
> will be triggered when you advance to the next increment on the page
> ### showoff:prev
> will be triggered when you switch to the previous page


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

