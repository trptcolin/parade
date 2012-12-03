!SLIDE subsection

# Custom events

> ### parade:show
> will be triggered as soon as you enter a page
> ### parade:next
> will be triggered when you switch to the next page
> ### parade:incr
> will be triggered when you advance to the next increment on the page
> ### parade:prev
> will be triggered when you switch to the previous page


!SLIDE custom_and_unique_class
# 1st Example h1
<script>
// bind to custom event
$(".custom_and_unique_class").bind("parade:show", function (event) {
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
$(".prevent_default").bind("parade:next", function (event) {
  var h1 = $(event.target).find("h1");
  if (h1.css("text-decoration") === "none") {
    event.preventDefault();
    h1.css({textDecoration: "line-through"})
  }
});
</script>

