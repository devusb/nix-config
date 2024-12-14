{ ... }:
{
  xdg.dataFile = {
    "kwin/scripts/firefoxsize/contents/code/main.js".text = ''
      var firefoxWidth = 1682;
      var firefoxHeight = 1084;

      function setWindowSize(client) {
          if (client.resourceName === "firefox" && client.caption === "Mozilla Firefox" && workspace.activeScreen.devicePixelRatio === 1.25) {
              client.frameGeometry = {
                  x: (workspace.activeScreen.geometry.width - firefoxWidth) / 2,
                  y: ((workspace.activeScreen.geometry.height - firefoxHeight) / 2) - 35,
                  width: firefoxWidth,
                  height: firefoxHeight
              };
          }
      }

      workspace.windowAdded.connect(setWindowSize);
    '';
    "kwin/scripts/firefoxsize/metadata.json".text = builtins.toJSON {
      KPlugin = {
        Name = "Firefox HiDPI Initial Size";
        Icon = "preferences-system-windows";
        Id = "firefoxsize";
      };
      "X-Plasma-API" = "javascript";
      "X-Plasma-MainScript" = "code/main.js";
      "KPackageStructure" = "KWin/Script";
    };
  };

}
