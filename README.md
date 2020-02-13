# Qt client side window decorations demo

Project to test the API for cross-platform client side window decorations in Qt which was introduced in Qt 5.15 ([QTBUG-73011](https://bugreports.qt.io/browse/QTBUG-73011)).

It should work on X11, Windows and macOS (macOS has no resize support though).

For Wayland support these additional patches are needed:

- https://codereview.qt-project.org/249758 (move)
- https://codereview.qt-project.org/249855 (resize)

Hopefully, they be merged soon and also part of Qt 5.15.

There are two demo applications in this project.

The `filebrowser` demo should look something like this:

![screenshot](https://i.imgur.com/avidazd.png)

The other demo `webbrowser.qml` is just a single file, and can just be run with

```sh
$ qml webbrowser.qml
```
