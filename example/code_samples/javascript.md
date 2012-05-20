!SLIDE
.notes notes for my slide

```javascript
function setupPreso() {
  if (preso_started)
  {
     alert("already started")
     return
  }
  preso_started = true

  loadSlides()
  doDebugStuff()

  document.onkeydown = keyDown
}
```
