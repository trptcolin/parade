!SLIDE

## JavaScript

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
!SLIDE execute

# Executable JavaScript

```javascript
3 + 3;
```
