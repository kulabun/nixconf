const electron = require("electron");
const app = electron.app;
const BrowserWindow = electron.BrowserWindow;

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

  win.webContents.on("new-window", function (e, url) {
    e.preventDefault();
    electron.shell.openExternal(url);
  });

  console.log(arguments);
  console.log(arguments.commandLine);
  win.loadURL(url);
}

app.on("ready", createWindow);
