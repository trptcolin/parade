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
# Strikethrough
<script>
// bind to custom event
$(".custom_and_unique_class").live("parade:show", function (event) {
  console.log("Performing show");
  // animate the h1
  var h1 = $(event.target).find("h1");
  h1.delay(500)
    .slideUp(300, function () { $(this).css({textDecoration: "line-through"}); })
    .slideDown(300);
    return false;
});
</script>

!SLIDE prevent_default
# 2nd Example h1
<script>
$(".prevent_default").live("parade:next", function (event) {
  var h1 = $(event.target).find("h1");
  if (h1.css("text-decoration") === "none") {
    h1.css({textDecoration: "line-through"})
    return false;
  }
});
</script>

