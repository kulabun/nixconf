const electron = require("electron");
const app = electron.app;
const session = electron.session;
const BrowserWindow = electron.BrowserWindow;

// TODO: cleanup this mess
// TODO: add support for screen sharing https://github.com/electron/electron/issues/4432

// when the name is set per aplication, each application will use different profile and so require independent login
// when it is not set, it will use the default profile and share it between all applications
if (app.commandLine.hasSwitch("wmclass")) {
  let wmClass = app.commandLine.getSwitchValue("wmclass");
  app.setName(wmClass);
  app.setDesktopName(wmClass);
}

let url = "https://google.com";
if (app.commandLine.hasSwitch("url")) {
  url = app.commandLine.getSwitchValue("url");
}

function createWindow() {
  let win = new BrowserWindow({
    width: 800,
    height: 600,
    autoHideMenuBar: true,
  });

  if (app.commandLine.hasSwitch("wmclass") && app.commandLine.hasSwitch("clear-user-agent")) {
    let wmClass = app.commandLine.getSwitchValue("wmclass");
    var re = new RegExp(`(${wmClass}/0.0|Electron/[0-9\.]+) `,"g");
    win.webContents.userAgent = win.webContents.userAgent.replace(re, '')

    session.defaultSession.webRequest.onBeforeSendHeaders((details, callback) => {
      details.requestHeaders['User-Agent'] = win.webContents.userAgent;
      callback({ cancel: false, requestHeaders: details.requestHeaders });
    });
  }

  if (app.commandLine.hasSwitch("title")) {
    win.setTitle(app.commandLine.getSwitchValue("title"));
  }

  // Open urls in external browser
  win.webContents.on("new-window", function (e, url) {
    e.preventDefault();
    electron.shell.openExternal(url);
  });

  // win.webContents.openDevTools()
  // Start the app with delay
  setTimeout(() => {
    win.loadURL(url)
  }, 100)
}

// no local cache for predictability
// app.commandLine.appendSwitch ("disable-http-cache");
app.on("ready", createWindow);

console.log(arguments);
console.log(arguments.commandLine);

