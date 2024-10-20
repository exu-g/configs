"use strict";
var Shortcut;
(function (Shortcut) {
    Shortcut[Shortcut["FocusNext"] = 0] = "FocusNext";
    Shortcut[Shortcut["FocusPrev"] = 1] = "FocusPrev";
    Shortcut[Shortcut["DWMLeft"] = 2] = "DWMLeft";
    Shortcut[Shortcut["DWMRight"] = 3] = "DWMRight";
    Shortcut[Shortcut["FocusUp"] = 4] = "FocusUp";
    Shortcut[Shortcut["FocusDown"] = 5] = "FocusDown";
    Shortcut[Shortcut["FocusLeft"] = 6] = "FocusLeft";
    Shortcut[Shortcut["FocusRight"] = 7] = "FocusRight";
    Shortcut[Shortcut["ShiftLeft"] = 8] = "ShiftLeft";
    Shortcut[Shortcut["ShiftRight"] = 9] = "ShiftRight";
    Shortcut[Shortcut["ShiftUp"] = 10] = "ShiftUp";
    Shortcut[Shortcut["ShiftDown"] = 11] = "ShiftDown";
    Shortcut[Shortcut["SwapUp"] = 12] = "SwapUp";
    Shortcut[Shortcut["SwapDown"] = 13] = "SwapDown";
    Shortcut[Shortcut["SwapLeft"] = 14] = "SwapLeft";
    Shortcut[Shortcut["SwapRight"] = 15] = "SwapRight";
    Shortcut[Shortcut["GrowWidth"] = 16] = "GrowWidth";
    Shortcut[Shortcut["GrowHeight"] = 17] = "GrowHeight";
    Shortcut[Shortcut["ShrinkWidth"] = 18] = "ShrinkWidth";
    Shortcut[Shortcut["ShrinkHeight"] = 19] = "ShrinkHeight";
    Shortcut[Shortcut["Increase"] = 20] = "Increase";
    Shortcut[Shortcut["Decrease"] = 21] = "Decrease";
    Shortcut[Shortcut["ShiftIncrease"] = 22] = "ShiftIncrease";
    Shortcut[Shortcut["ShiftDecrease"] = 23] = "ShiftDecrease";
    Shortcut[Shortcut["ToggleFloat"] = 24] = "ToggleFloat";
    Shortcut[Shortcut["ToggleFloatAll"] = 25] = "ToggleFloatAll";
    Shortcut[Shortcut["SetMaster"] = 26] = "SetMaster";
    Shortcut[Shortcut["NextLayout"] = 27] = "NextLayout";
    Shortcut[Shortcut["PreviousLayout"] = 28] = "PreviousLayout";
    Shortcut[Shortcut["SetLayout"] = 29] = "SetLayout";
    Shortcut[Shortcut["Rotate"] = 30] = "Rotate";
    Shortcut[Shortcut["RotatePart"] = 31] = "RotatePart";
})(Shortcut || (Shortcut = {}));
let CONFIG;
class KWinConfig {
    constructor() {
        function commaSeparate(str) {
            if (!str || typeof str !== "string")
                return [];
            return str
                .split(",")
                .map((part) => part.trim())
                .filter((part) => part != "");
        }
        DEBUG.enabled = DEBUG.enabled || KWIN.readConfig("debug", false);
        this.layoutOrder = [];
        this.layoutFactories = {};
        [
            ["enableTileLayout", true, TileLayout],
            ["enableMonocleLayout", true, MonocleLayout],
            ["enableColumnsLayout", true, ColumnsLayout],
            ["enableThreeColumnLayout", true, ThreeColumnLayout],
            ["enableSpreadLayout", true, SpreadLayout],
            ["enableStairLayout", true, StairLayout],
            ["enableSpiralLayout", true, SpiralLayout],
            ["enableQuarterLayout", false, QuarterLayout],
            ["enableStackedLayout", false, StackedLayout],
            ["enableFloatingLayout", false, FloatingLayout],
            ["enableBTreeLayout", false, BTreeLayout],
            ["enableCascadeLayout", false, CascadeLayout],
        ].forEach(([configKey, defaultValue, layoutClass]) => {
            if (KWIN.readConfig(configKey, defaultValue))
                this.layoutOrder.push(layoutClass.id);
            this.layoutFactories[layoutClass.id] = () => new layoutClass();
        });
        this.maximizeSoleTile = KWIN.readConfig("maximizeSoleTile", false);
        this.tileLayoutInitialAngle = KWIN.readConfig("tileLayoutInitialRotationAngle", "0");
        this.columnsLayoutInitialAngle = KWIN.readConfig("columnsLayoutInitialRotationAngle", "0");
        this.columnsBalanced = KWIN.readConfig("columnsBalanced", false);
        this.monocleMaximize = KWIN.readConfig("monocleMaximize", true);
        this.monocleMinimizeRest = KWIN.readConfig("monocleMinimizeRest", false);
        this.stairReverse = KWIN.readConfig("stairReverse", false);
        this.adjustLayout = KWIN.readConfig("adjustLayout", true);
        this.adjustLayoutLive = KWIN.readConfig("adjustLayoutLive", true);
        this.keepFloatAbove = KWIN.readConfig("keepFloatAbove", true);
        this.keepTilingOnDrag = KWIN.readConfig("keepTilingOnDrag", true);
        this.noTileBorder = KWIN.readConfig("noTileBorder", false);
        this.limitTileWidthRatio = 0;
        if (KWIN.readConfig("limitTileWidth", false))
            this.limitTileWidthRatio = KWIN.readConfig("limitTileWidthRatio", 1.6);
        this.screenGapBottom = KWIN.readConfig("screenGapBottom", 0);
        this.screenGapLeft = KWIN.readConfig("screenGapLeft", 0);
        this.screenGapRight = KWIN.readConfig("screenGapRight", 0);
        this.screenGapTop = KWIN.readConfig("screenGapTop", 0);
        this.tileLayoutGap = KWIN.readConfig("tileLayoutGap", 0);
        const directionalKeyDwm = KWIN.readConfig("directionalKeyDwm", false);
        const directionalKeyFocus = KWIN.readConfig("directionalKeyFocus", true);
        this.directionalKeyMode = directionalKeyDwm ? "dwm" : "focus";
        this.newWindowPosition = KWIN.readConfig("newWindowPosition", 0);
        this.layoutPerActivity = KWIN.readConfig("layoutPerActivity", true);
        this.layoutPerDesktop = KWIN.readConfig("layoutPerDesktop", true);
        this.floatUtility = KWIN.readConfig("floatUtility", true);
        this.preventMinimize = KWIN.readConfig("preventMinimize", false);
        this.preventProtrusion = KWIN.readConfig("preventProtrusion", true);
        this.pollMouseXdotool = KWIN.readConfig("pollMouseXdotool", false);
        this.floatingClass = commaSeparate(KWIN.readConfig("floatingClass", ""));
        this.floatingTitle = commaSeparate(KWIN.readConfig("floatingTitle", ""));
        this.ignoreActivity = commaSeparate(KWIN.readConfig("ignoreActivity", ""));
        this.ignoreClass = commaSeparate(KWIN.readConfig("ignoreClass", "krunner,yakuake,spectacle,kded5,xwaylandvideobridge,plasmashell,ksplashqml"));
        this.ignoreRole = commaSeparate(KWIN.readConfig("ignoreRole", "quake"));
        this.ignoreScreen = commaSeparate(KWIN.readConfig("ignoreScreen", ""));
        this.ignoreVDesktop = commaSeparate(KWIN.readConfig("ignoreVDesktop", ""));
        this.ignoreTitle = commaSeparate(KWIN.readConfig("ignoreTitle", ""));
        this.screenDefaultLayout = commaSeparate(KWIN.readConfig("screenDefaultLayout", ""));
        if (this.preventMinimize && this.monocleMinimizeRest) {
            debug(() => "preventMinimize is disabled because of monocleMinimizeRest.");
            this.preventMinimize = false;
        }
    }
    toString() {
        return "Config(" + JSON.stringify(this, undefined, 2) + ")";
    }
}
var KWINCONFIG;
var KWIN;
class KWinDriver {
    get backend() {
        return KWinDriver.backendName;
    }
    get currentSurface() {
        return new KWinSurface(this.workspace.activeWindow
            ? this.workspace.activeWindow.output
            : this.workspace.activeScreen, this.workspace.currentActivity, this.workspace.currentDesktop, this.workspace);
    }
    set currentSurface(value) {
        const ksrf = value;
        if (this.workspace.currentDesktop.name !== ksrf.desktop.name)
            this.workspace.currentDesktop = ksrf.desktop;
        if (this.workspace.currentActivity !== ksrf.activity)
            this.workspace.currentActivity = ksrf.activity;
    }
    get currentWindow() {
        const client = this.workspace.activeWindow;
        return client ? this.windowMap.get(client) : null;
    }
    set currentWindow(window) {
        if (window !== null)
            this.workspace.activeWindow = window.window.window;
    }
    get screens() {
        const screens = [];
        this.workspace.screens.forEach((screen) => {
            screens.push(new KWinSurface(screen, this.workspace.currentActivity, this.workspace.currentDesktop, this.workspace));
        });
        return screens;
    }
    get cursorPosition() {
        return this.mousePoller.mousePosition;
    }
    constructor(api) {
        KWIN = api.kwin;
        this.workspace = api.workspace;
        this.shortcuts = api.shortcuts;
        this.engine = new TilingEngine();
        this.control = new TilingController(this.engine);
        this.windowMap = new WrapperMap((client) => KWinWindow.generateID(client), (client) => new WindowClass(new KWinWindow(client, this.workspace)));
        this.entered = false;
        this.mousePoller = new KWinMousePoller();
    }
    main() {
        CONFIG = KWINCONFIG = new KWinConfig();
        debug(() => "Config: " + KWINCONFIG);
        this.bindEvents();
        this.bindShortcut();
        const clients = this.workspace.stackingOrder;
        for (let i = 0; i < clients.length; i++) {
            this.addWindow(clients[i]);
        }
    }
    addWindow(client) {
        if (!client.deleted &&
            client.pid >= 0 &&
            !client.popupWindow &&
            client.normalWindow &&
            !client.hidden &&
            client.width * client.height > 10) {
            if (KWIN.readConfig("debugActiveWin", false))
                print(debugWin(client));
            const window = this.windowMap.add(client);
            this.control.onWindowAdded(this, window);
            if (window.state !== WindowState.Unmanaged) {
                this.bindWindowEvents(window, client);
                return window;
            }
            else {
                this.windowMap.remove(client);
                if (KWIN.readConfig("debugActiveWin", false))
                    print("Unmanaged: " + debugWin(client));
            }
        }
        else {
            if (KWIN.readConfig("debugActiveWin", false))
                print("Filtered: " + debugWin(client));
        }
        return null;
    }
    setTimeout(func, timeout) {
        KWinSetTimeout(() => this.enter(func), timeout);
    }
    showNotification(text) {
        popupDialog.show(text);
    }
    bindShortcut() {
        const callbackShortcut = (shortcut) => {
            return () => {
                this.enter(() => this.control.onShortcut(this, shortcut));
            };
        };
        this.shortcuts
            .getFocusNext()
            .activated.connect(callbackShortcut(Shortcut.FocusNext));
        this.shortcuts
            .getFocusPrev()
            .activated.connect(callbackShortcut(Shortcut.FocusPrev));
        this.shortcuts
            .getFocusDown()
            .activated.connect(callbackShortcut(Shortcut.FocusDown));
        this.shortcuts
            .getFocusUp()
            .activated.connect(callbackShortcut(Shortcut.FocusUp));
        this.shortcuts
            .getFocusLeft()
            .activated.connect(callbackShortcut(Shortcut.FocusLeft));
        this.shortcuts
            .getFocusRight()
            .activated.connect(callbackShortcut(Shortcut.FocusRight));
        this.shortcuts
            .getShiftDown()
            .activated.connect(callbackShortcut(Shortcut.ShiftDown));
        this.shortcuts
            .getShiftUp()
            .activated.connect(callbackShortcut(Shortcut.ShiftUp));
        this.shortcuts
            .getShiftLeft()
            .activated.connect(callbackShortcut(Shortcut.ShiftLeft));
        this.shortcuts
            .getShiftRight()
            .activated.connect(callbackShortcut(Shortcut.ShiftRight));
        this.shortcuts
            .getGrowHeight()
            .activated.connect(callbackShortcut(Shortcut.GrowHeight));
        this.shortcuts
            .getShrinkHeight()
            .activated.connect(callbackShortcut(Shortcut.ShrinkHeight));
        this.shortcuts
            .getShrinkWidth()
            .activated.connect(callbackShortcut(Shortcut.ShrinkWidth));
        this.shortcuts
            .getGrowWidth()
            .activated.connect(callbackShortcut(Shortcut.GrowWidth));
        this.shortcuts
            .getIncrease()
            .activated.connect(callbackShortcut(Shortcut.Increase));
        this.shortcuts
            .getDecrease()
            .activated.connect(callbackShortcut(Shortcut.Decrease));
        this.shortcuts
            .getToggleFloat()
            .activated.connect(callbackShortcut(Shortcut.ToggleFloat));
        this.shortcuts
            .getFloatAll()
            .activated.connect(callbackShortcut(Shortcut.ToggleFloatAll));
        this.shortcuts
            .getNextLayout()
            .activated.connect(callbackShortcut(Shortcut.NextLayout));
        this.shortcuts
            .getPreviousLayout()
            .activated.connect(callbackShortcut(Shortcut.PreviousLayout));
        this.shortcuts
            .getRotate()
            .activated.connect(callbackShortcut(Shortcut.Rotate));
        this.shortcuts
            .getRotatePart()
            .activated.connect(callbackShortcut(Shortcut.RotatePart));
        this.shortcuts
            .getSetMaster()
            .activated.connect(callbackShortcut(Shortcut.SetMaster));
        const callbackShortcutLayout = (layoutClass) => {
            return () => {
                this.enter(() => this.control.onShortcut(this, Shortcut.SetLayout, layoutClass.id));
            };
        };
        this.shortcuts
            .getTileLayout()
            .activated.connect(callbackShortcutLayout(TileLayout));
        this.shortcuts
            .getMonocleLayout()
            .activated.connect(callbackShortcutLayout(MonocleLayout));
        this.shortcuts
            .getThreeColumnLayout()
            .activated.connect(callbackShortcutLayout(ThreeColumnLayout));
        this.shortcuts
            .getSpreadLayout()
            .activated.connect(callbackShortcutLayout(SpreadLayout));
        this.shortcuts
            .getStairLayout()
            .activated.connect(callbackShortcutLayout(StairLayout));
        this.shortcuts
            .getFloatingLayout()
            .activated.connect(callbackShortcutLayout(FloatingLayout));
        this.shortcuts
            .getQuarterLayout()
            .activated.connect(callbackShortcutLayout(QuarterLayout));
        this.shortcuts
            .getStackedLayout()
            .activated.connect(callbackShortcutLayout(StackedLayout));
        this.shortcuts
            .getColumnsLayout()
            .activated.connect(callbackShortcutLayout(ColumnsLayout));
        this.shortcuts
            .getSpiralLayout()
            .activated.connect(callbackShortcutLayout(SpiralLayout));
        this.shortcuts
            .getBTreeLayout()
            .activated.connect(callbackShortcutLayout(BTreeLayout));
    }
    connect(signal, handler) {
        const wrapper = (...args) => {
            if (typeof this.workspace === "undefined")
                signal.disconnect(wrapper);
            else
                this.enter(() => handler.apply(this, args));
        };
        signal.connect(wrapper);
        return wrapper;
    }
    enter(callback) {
        if (this.entered)
            return;
        this.entered = true;
        try {
            callback();
        }
        catch (e) {
            debug(() => "Error raised from line " + e.lineNumber);
            debug(() => e);
        }
        finally {
            this.entered = false;
        }
    }
    bindEvents() {
        this.connect(this.workspace.screensChanged, () => this.control.onSurfaceUpdate(this, "screens (Outputs) changed"));
        this.connect(this.workspace.virtualScreenGeometryChanged, () => {
            this.control.onSurfaceUpdate(this, "virtualScreenGeometryChanged");
        });
        this.connect(this.workspace.currentActivityChanged, (activityId) => this.control.onCurrentActivityChanged(this, activityId));
        this.connect(this.workspace.currentDesktopChanged, (virtualDesktop) => this.control.onSurfaceUpdate(this, "currentDesktopChanged"));
        this.connect(this.workspace.windowAdded, (client) => {
            const window = this.addWindow(client);
            if (client.active && window !== null)
                this.control.onWindowFocused(this, window);
        });
        this.connect(this.workspace.windowActivated, (client) => {
            const window = this.windowMap.get(client);
            if (client.active && window !== null)
                this.control.onWindowFocused(this, window);
        });
        this.connect(this.workspace.windowRemoved, (client) => {
            const window = this.windowMap.get(client);
            if (window) {
                this.control.onWindowRemoved(this, window);
                this.windowMap.remove(client);
            }
        });
    }
    bindWindowEvents(window, client) {
        let moving = false;
        let resizing = false;
        this.connect(client.maximizedAboutToChange, (mode) => {
            const maximized = mode === 3;
            window.window.maximized = maximized;
            this.control.onWindowMaximizeChanged(this, window, maximized);
        });
        this.connect(client.minimizedChanged, () => {
            if (KWINCONFIG.preventMinimize) {
                client.minimized = false;
                this.workspace.activeWindow = client;
            }
            else {
                var comment = client.minimized ? "minimized" : "unminimized";
                this.control.onWindowChanged(this, window, comment);
            }
        });
        this.connect(client.fullScreenChanged, () => this.control.onWindowChanged(this, window, "fullscreen=" + client.fullScreen));
        this.connect(client.interactiveMoveResizeStepped, (geometry) => {
            if (client.resize)
                return;
            this.control.onWindowDragging(this, window, geometry);
        });
        this.connect(client.moveResizedChanged, () => {
            debugObj(() => [
                "moveResizedChanged",
                { window, move: client.move, resize: client.resize },
            ]);
            if (moving !== client.move) {
                moving = client.move;
                if (moving) {
                    this.mousePoller.start();
                    this.control.onWindowMoveStart(window);
                }
                else {
                    this.control.onWindowMoveOver(this, window);
                    this.mousePoller.stop();
                }
            }
            if (resizing !== client.resize) {
                resizing = client.resize;
                if (resizing)
                    this.control.onWindowResizeStart(window);
                else
                    this.control.onWindowResizeOver(this, window);
            }
        });
        this.connect(client.bufferGeometryChanged, () => {
            if (moving)
                this.control.onWindowMove(window);
            else if (resizing)
                this.control.onWindowResize(this, window);
            else {
                if (!window.actualGeometry.equals(window.geometry))
                    this.control.onWindowGeometryChanged(this, window);
            }
        });
        this.connect(client.outputChanged, () => this.control.onWindowChanged(this, window, "screen=" + client.output.name));
        this.connect(client.activitiesChanged, () => this.control.onWindowChanged(this, window, "activity=" + client.activities.join(",")));
        this.connect(client.desktopsChanged, () => this.control.onWindowChanged(this, window, "Window's desktop changed."));
    }
}
KWinDriver.backendName = "kwin";
class KWinMousePoller {
    get started() {
        return this.startCount > 0;
    }
    get mousePosition() {
        return this.parseResult();
    }
    constructor() {
        this.startCount = 0;
        this.cmdResult = null;
        mousePoller.interval = 0;
        mousePoller.onNewData.connect((sourceName, data) => {
            this.cmdResult = data["exit code"] === 0 ? data["stdout"] : null;
            mousePoller.disconnectSource(KWinMousePoller.COMMAND);
            KWinSetTimeout(() => {
                if (this.started)
                    mousePoller.connectSource(KWinMousePoller.COMMAND);
            }, KWinMousePoller.INTERVAL);
        });
    }
    start() {
        this.startCount += 1;
        if (KWINCONFIG.pollMouseXdotool)
            mousePoller.connectSource(KWinMousePoller.COMMAND);
    }
    stop() {
        this.startCount = Math.max(this.startCount - 1, 0);
    }
    parseResult() {
        if (!this.cmdResult)
            return null;
        let x = null;
        let y = null;
        this.cmdResult
            .split(" ")
            .slice(0, 2)
            .forEach((part) => {
            const [key, value, _] = part.split(":");
            if (key === "x")
                x = parseInt(value, 10);
            if (key === "y")
                y = parseInt(value, 10);
        });
        if (x === null || y === null)
            return null;
        return [x, y];
    }
}
KWinMousePoller.COMMAND = "xdotool getmouselocation";
KWinMousePoller.INTERVAL = 50;
class KWinTimerPool {
    constructor() {
        this.timers = [];
        this.numTimers = 0;
    }
    setTimeout(func, timeout) {
        if (this.timers.length === 0) {
            this.numTimers++;
            debugObj(() => ["setTimeout/newTimer", { numTimers: this.numTimers }]);
        }
        const timer = this.timers.pop() ||
            Qt.createQmlObject("import QtQuick 2.0; Timer {}", scriptRoot);
        const callback = () => {
            try {
                timer.triggered.disconnect(callback);
            }
            catch (e) {
            }
            try {
                func();
            }
            catch (e) {
            }
            this.timers.push(timer);
        };
        timer.interval = timeout;
        timer.repeat = false;
        timer.triggered.connect(callback);
        timer.start();
    }
}
KWinTimerPool.instance = new KWinTimerPool();
function KWinSetTimeout(func, timeout) {
    KWinTimerPool.instance.setTimeout(func, timeout);
}
class KWinSurface {
    static generateId(screenName, activity, desktopName) {
        let path = screenName;
        if (KWINCONFIG.layoutPerActivity)
            path += "@" + activity;
        if (KWINCONFIG.layoutPerDesktop)
            path += "#" + desktopName;
        return path;
    }
    constructor(output, activity, desktop, workspace) {
        this.id = KWinSurface.generateId(output.name, activity, desktop.name);
        this.ignore =
            KWINCONFIG.ignoreActivity.indexOf(activity) >= 0 ||
                KWINCONFIG.ignoreScreen.indexOf(output.name) >= 0 ||
                KWINCONFIG.ignoreVDesktop.indexOf(desktop.name) >= 0;
        this.workingArea = toRect(workspace.clientArea(0, output, desktop));
        this.output = output;
        this.activity = activity;
        this.desktop = desktop;
    }
    next() {
        return null;
    }
    toString() {
        return ("KWinSurface(" +
            [this.output.name, this.activity, this.desktop.name].join(", ") +
            ")");
    }
}
class KWinWindow {
    static generateID(w) {
        return w.internalId.toString();
    }
    get fullScreen() {
        return this.window.fullScreen;
    }
    get geometry() {
        return toRect(this.window.frameGeometry);
    }
    get shouldIgnore() {
        if (this.window.deleted)
            return true;
        const resourceClass = String(this.window.resourceClass);
        const resourceName = String(this.window.resourceName);
        const windowRole = String(this.window.windowRole);
        return (this.window.specialWindow ||
            resourceClass === "plasmashell" ||
            KWINCONFIG.ignoreClass.indexOf(resourceClass) >= 0 ||
            KWINCONFIG.ignoreClass.indexOf(resourceName) >= 0 ||
            matchWords(this.window.caption, KWINCONFIG.ignoreTitle) >= 0 ||
            KWINCONFIG.ignoreRole.indexOf(windowRole) >= 0);
    }
    get shouldFloat() {
        const resourceClass = String(this.window.resourceClass);
        const resourceName = String(this.window.resourceName);
        const moreOneDesktop = this.window.desktops.length !== 1;
        return (moreOneDesktop ||
            this.window.onAllDesktops ||
            this.window.modal ||
            this.window.transient ||
            !this.window.resizeable ||
            (KWINCONFIG.floatUtility &&
                (this.window.dialog || this.window.splash || this.window.utility)) ||
            KWINCONFIG.floatingClass.indexOf(resourceClass) >= 0 ||
            KWINCONFIG.floatingClass.indexOf(resourceName) >= 0 ||
            matchWords(this.window.caption, KWINCONFIG.floatingTitle) >= 0);
    }
    get minimized() {
        return this.window.minimized;
    }
    get surface() {
        let activity;
        if (this.window.activities.length === 0)
            activity = this.workspace.currentActivity;
        else if (this.window.activities.indexOf(this.workspace.currentActivity) >= 0)
            activity = this.workspace.currentActivity;
        else
            activity = this.window.activities[0];
        const desktop = this.window.desktops[0];
        return new KWinSurface(this.window.output, activity, desktop, this.workspace);
    }
    set surface(srf) {
        const ksrf = srf;
        if (this.window.desktops[0] !== ksrf.desktop)
            this.window.desktops = [ksrf.desktop];
        if (this.window.activities[0] !== ksrf.activity)
            this.window.activities = [ksrf.activity];
    }
    constructor(window, workspace) {
        this.workspace = workspace;
        this.window = window;
        this.id = KWinWindow.generateID(window);
        this.maximized = false;
        this.noBorderManaged = false;
        this.noBorderOriginal = window.noBorder;
    }
    commit(geometry, noBorder, keepAbove) {
        debugObj(() => ["KWinWindow#commit", { geometry, noBorder, keepAbove }]);
        if (this.window.move || this.window.resize)
            return;
        if (noBorder !== undefined) {
            if (!this.noBorderManaged && noBorder)
                this.noBorderOriginal = this.window.noBorder;
            else if (this.noBorderManaged && !this.window.noBorder)
                this.noBorderOriginal = false;
            if (noBorder)
                this.window.noBorder = true;
            else if (this.noBorderManaged)
                this.window.noBorder = this.noBorderOriginal;
            this.noBorderManaged = noBorder;
        }
        if (keepAbove !== undefined)
            this.window.keepAbove = keepAbove;
        if (geometry !== undefined) {
            geometry = this.adjustGeometry(geometry);
            if (KWINCONFIG.preventProtrusion) {
                const area = toRect(this.workspace.clientArea(0, this.window.output, this.workspace.currentDesktop));
                if (!area.includes(geometry)) {
                    const x = geometry.x + Math.min(area.maxX - geometry.maxX, 0);
                    const y = geometry.y + Math.min(area.maxY - geometry.maxY, 0);
                    geometry = new Rect(x, y, geometry.width, geometry.height);
                    geometry = this.adjustGeometry(geometry);
                }
            }
            if (this.window.deleted)
                return;
            this.window.frameGeometry = toQRect(geometry);
        }
    }
    toString() {
        return ("KWin(" +
            this.window.internalId.toString() +
            "." +
            this.window.resourceClass +
            ")");
    }
    visible(srf) {
        const ksrf = srf;
        return (!this.window.deleted &&
            !this.window.minimized &&
            (this.window.onAllDesktops ||
                this.window.desktops.indexOf(ksrf.desktop) !== -1) &&
            (this.window.activities.length === 0 ||
                this.window.activities.indexOf(ksrf.activity) !== -1) &&
            this.window.output === ksrf.output);
    }
    adjustGeometry(geometry) {
        let width = geometry.width;
        let height = geometry.height;
        if (!this.window.resizeable) {
            width = this.window.width;
            height = this.window.height;
        }
        else {
            width = clip(width, this.window.minSize.width, this.window.maxSize.width);
            height = clip(height, this.window.minSize.height, this.window.maxSize.height);
        }
        return new Rect(geometry.x, geometry.y, width, height);
    }
}
function debugWin(win) {
    var w_props = [
        { name: "caption", opt: win.caption },
        { name: "output.name", opt: win.output.name },
        { name: "resourceName", opt: win.resourceName },
        { name: "resourceClass", opt: win.resourceClass },
        { name: "desktopWindow", opt: win.desktopWindow },
        { name: "windowRole", opt: win.windowRole },
        { name: "windowType", opt: win.windowType },
        { name: "pid", opt: win.pid },
        { name: "internalId", opt: win.internalId },
        { name: "stackingOrder", opt: win.stackingOrder },
        { name: "size", opt: win.size },
        { name: "width", opt: win.width },
        { name: "height", opt: win.height },
        { name: "dock", opt: win.dock },
        { name: "toolbar", opt: win.toolbar },
        { name: "menu", opt: win.menu },
        { name: "dialog", opt: win.dialog },
        { name: "splash", opt: win.splash },
        { name: "utility", opt: win.utility },
        { name: "dropdownMenu", opt: win.dropdownMenu },
        { name: "popupMenu", opt: win.popupMenu },
        { name: "tooltip", opt: win.tooltip },
        { name: "notification", opt: win.notification },
        { name: "criticalNotification", opt: win.criticalNotification },
        { name: "appletPopup", opt: win.appletPopup },
        { name: "onScreenDisplay", opt: win.onScreenDisplay },
        { name: "comboBox", opt: win.comboBox },
        { name: "managed", opt: win.managed },
        { name: "popupWindow", opt: win.popupWindow },
        { name: "outline", opt: win.outline },
        { name: "fullScreenable", opt: win.fullScreenable },
        { name: "closeable", opt: win.closeable },
        { name: "minimizable", opt: win.minimizable },
        { name: "specialWindow", opt: win.specialWindow },
        { name: "modal", opt: win.modal },
        { name: "resizeable", opt: win.resizeable },
        { name: "minimized", opt: win.minimized },
        { name: "tile", opt: win.tile },
        { name: "minSize", opt: win.minSize },
        { name: "maxSize", opt: win.maxSize },
        { name: "transient", opt: win.transient },
        { name: "transientFor", opt: win.transientFor },
        { name: "maximizable", opt: win.maximizable },
        { name: "moveable", opt: win.moveable },
        { name: "moveableAcrossScreens", opt: win.moveableAcrossScreens },
        { name: "hidden", opt: win.hidden },
        { name: "keepAbove", opt: win.keepAbove },
        { name: "keepBelow", opt: win.keepBelow },
        { name: "opacity", opt: win.opacity },
    ];
    var s = "krohnkite:";
    w_props.forEach((el) => {
        if (typeof el.opt !== "undefined" &&
            (el.opt || el.opt === 0 || el.opt === "0")) {
            s += "<";
            s += el.name;
            s += ": ";
            s += el.opt;
            s += "> ";
        }
    });
    return s;
}
class TestDriver {
    constructor() {
        this.currentScreen = 0;
        this.currentWindow = 0;
        this.numScreen = 1;
        this.screenSize = new Rect(0, 0, 10000, 10000);
        this.windows = [];
    }
    forEachScreen(func) {
        for (let screen = 0; screen < this.numScreen; screen++)
            func(new TestSurface(this, screen));
    }
    getCurrentContext() {
        const window = this.getCurrentWindow();
        if (window)
            return window.surface;
        return new TestSurface(this, 0);
    }
    getCurrentWindow() {
        return this.windows.length !== 0 ? this.windows[this.currentWindow] : null;
    }
    getWorkingArea(srf) {
        return this.screenSize;
    }
    setCurrentWindow(window) {
        const idx = this.windows.indexOf(window);
        if (idx !== -1)
            this.currentWindow = idx;
    }
    setTimeout(func, timeout) {
        setTimeout(func, timeout);
    }
}
class TestSurface {
    get id() {
        return String(this.screen);
    }
    get ignore() {
        return false;
    }
    get workingArea() {
        return this.driver.screenSize;
    }
    constructor(driver, screen) {
        this.driver = driver;
        this.screen = screen;
    }
    next() {
        return new TestSurface(this.driver, this.screen + 1);
    }
}
class TestWindow {
    constructor(srf, geometry, ignore, float) {
        this.id = String(TestWindow.windowCount);
        TestWindow.windowCount += 1;
        this.shouldFloat = float !== undefined ? float : false;
        this.shouldIgnore = ignore !== undefined ? ignore : false;
        this.surface = srf;
        this.fullScreen = false;
        this.geometry = geometry || new Rect(0, 0, 100, 100);
        this.keepAbove = false;
        this.maximized = false;
        this.minimized = false;
        this.noBorder = false;
    }
    commit(geometry, noBorder, keepAbove) {
        if (geometry)
            this.geometry = geometry;
        if (noBorder !== undefined)
            this.noBorder = noBorder;
        if (keepAbove !== undefined)
            this.keepAbove = keepAbove;
    }
    focus() {
    }
    visible(srf) {
        const tctx = srf;
        return this.surface.screen === tctx.screen;
    }
}
TestWindow.windowCount = 0;
function setTestConfig(name, value) {
    if (!CONFIG)
        CONFIG = {};
    CONFIG[name] = value;
}
class TilingController {
    constructor(engine) {
        this.engine = engine;
        this.isDragging = false;
        this.dragCompleteTime = null;
    }
    onSurfaceUpdate(ctx, comment) {
        debugObj(() => ["onSurfaceUpdate", { comment }]);
        this.engine.arrange(ctx);
    }
    onCurrentActivityChanged(ctx, activityId) {
        debugObj(() => ["onCurrentActivityChanged", { activityId: activityId }]);
        this.engine.arrange(ctx);
    }
    onCurrentSurfaceChanged(ctx) {
        debugObj(() => ["onCurrentSurfaceChanged", { srf: ctx.currentSurface }]);
        this.engine.arrange(ctx);
    }
    onWindowAdded(ctx, window) {
        debugObj(() => ["onWindowAdded", { window }]);
        this.engine.manage(window);
        if (window.tileable) {
            const srf = ctx.currentSurface;
            const tiles = this.engine.windows.getVisibleTiles(srf);
            const layoutCapcity = this.engine.layouts.getCurrentLayout(srf).capacity;
            if (layoutCapcity !== undefined && tiles.length > layoutCapcity) {
                const nsrf = ctx.currentSurface.next();
                if (nsrf) {
                    window.surface = nsrf;
                    ctx.currentSurface = nsrf;
                }
            }
        }
        this.engine.arrange(ctx);
    }
    onWindowRemoved(ctx, window) {
        debugObj(() => ["onWindowRemoved", { window }]);
        this.engine.unmanage(window);
        this.engine.arrange(ctx);
    }
    onWindowMoveStart(window) {
    }
    onWindowMove(window) {
    }
    onWindowDragging(ctx, window, windowRect) {
        if (this.isDragging)
            return;
        if (this.dragCompleteTime !== null &&
            Date.now() - this.dragCompleteTime < 100)
            return;
        const srf = ctx.currentSurface;
        const layout = this.engine.layouts.getCurrentLayout(srf);
        if (!layout.drag)
            return;
        if (window.state === WindowState.Tiled) {
            window.setDraggingState();
        }
        if (window.state === WindowState.Dragging) {
            if (layout.drag(new EngineContext(ctx, this.engine), toRect(windowRect), window, srf.workingArea)) {
                this.engine.arrange(ctx);
            }
            this.dragCompleteTime = Date.now();
        }
        this.isDragging = false;
    }
    onWindowMoveOver(ctx, window) {
        debugObj(() => ["onWindowMoveOver", { window }]);
        if (window.state === WindowState.Dragging) {
            window.removeDraggingState(WindowState.Tiled);
            this.engine.arrange(ctx);
            return;
        }
        if (window.state === WindowState.Tiled) {
            const tiles = this.engine.windows.getVisibleTiles(ctx.currentSurface);
            const cursorPos = ctx.cursorPosition || window.actualGeometry.center;
            const targets = tiles.filter((tile) => tile !== window && tile.actualGeometry.includesPoint(cursorPos));
            if (targets.length === 1) {
                this.engine.windows.swap(window, targets[0]);
                this.engine.arrange(ctx);
                return;
            }
        }
        if (!CONFIG.keepTilingOnDrag && window.state === WindowState.Tiled) {
            const diff = window.actualGeometry.subtract(window.geometry);
            const distance = Math.sqrt(Math.pow(diff.x, 2) + Math.pow(diff.y, 2));
            if (distance > 30) {
                window.floatGeometry = window.actualGeometry;
                window.state = WindowState.Floating;
                this.engine.arrange(ctx);
                return;
            }
        }
        window.commit();
    }
    onWindowResizeStart(window) {
    }
    onWindowResize(ctx, window) {
        debugObj(() => ["onWindowResize", { window }]);
        if (CONFIG.adjustLayout && CONFIG.adjustLayoutLive) {
            if (window.state === WindowState.Tiled) {
                this.engine.adjustLayout(window);
                this.engine.arrange(ctx);
            }
        }
    }
    onWindowResizeOver(ctx, window) {
        debugObj(() => ["onWindowResizeOver", { window }]);
        if (CONFIG.adjustLayout && window.tiled) {
            this.engine.adjustLayout(window);
            this.engine.arrange(ctx);
        }
        else if (!CONFIG.adjustLayout)
            this.engine.enforceSize(ctx, window);
    }
    onWindowMaximizeChanged(ctx, window, maximized) {
        this.engine.arrange(ctx);
    }
    onWindowGeometryChanged(ctx, window) {
        debugObj(() => ["onWindowGeometryChanged", { window }]);
        this.engine.enforceSize(ctx, window);
    }
    onWindowChanged(ctx, window, comment) {
        if (window) {
            debugObj(() => ["onWindowChanged", { window, comment }]);
            if (comment === "unminimized")
                ctx.currentWindow = window;
            this.engine.arrange(ctx);
        }
    }
    onWindowFocused(ctx, window) {
        window.timestamp = new Date().getTime();
    }
    onShortcut(ctx, input, data) {
        if (CONFIG.directionalKeyMode === "dwm") {
            switch (input) {
                case Shortcut.FocusUp:
                    input = Shortcut.FocusNext;
                    break;
                case Shortcut.FocusDown:
                    input = Shortcut.FocusPrev;
                    break;
                case Shortcut.FocusLeft:
                    input = Shortcut.DWMLeft;
                    break;
                case Shortcut.FocusRight:
                    input = Shortcut.DWMRight;
                    break;
            }
        }
        else if (CONFIG.directionalKeyMode === "focus") {
            switch (input) {
                case Shortcut.ShiftUp:
                    input = Shortcut.SwapUp;
                    break;
                case Shortcut.ShiftDown:
                    input = Shortcut.SwapDown;
                    break;
                case Shortcut.ShiftLeft:
                    input = Shortcut.SwapLeft;
                    break;
                case Shortcut.ShiftRight:
                    input = Shortcut.SwapRight;
                    break;
            }
        }
        if (this.engine.handleLayoutShortcut(ctx, input, data)) {
            this.engine.arrange(ctx);
            return;
        }
        const window = ctx.currentWindow;
        switch (input) {
            case Shortcut.FocusNext:
                this.engine.focusOrder(ctx, -1);
                break;
            case Shortcut.FocusPrev:
                this.engine.focusOrder(ctx, +1);
                break;
            case Shortcut.FocusUp:
                this.engine.focusDir(ctx, "up");
                break;
            case Shortcut.FocusDown:
                this.engine.focusDir(ctx, "down");
                break;
            case Shortcut.DWMLeft:
            case Shortcut.FocusLeft:
                this.engine.focusDir(ctx, "left");
                break;
            case Shortcut.DWMRight:
            case Shortcut.FocusRight:
                this.engine.focusDir(ctx, "right");
                break;
            case Shortcut.GrowWidth:
                if (window)
                    this.engine.resizeWindow(window, "east", 1);
                break;
            case Shortcut.ShrinkWidth:
                if (window)
                    this.engine.resizeWindow(window, "east", -1);
                break;
            case Shortcut.GrowHeight:
                if (window)
                    this.engine.resizeWindow(window, "south", 1);
                break;
            case Shortcut.ShrinkHeight:
                if (window)
                    this.engine.resizeWindow(window, "south", -1);
                break;
            case Shortcut.ShiftUp:
                if (window)
                    this.engine.swapOrder(window, -1);
                break;
            case Shortcut.ShiftDown:
                if (window)
                    this.engine.swapOrder(window, +1);
                break;
            case Shortcut.SwapUp:
                this.engine.swapDirOrMoveFloat(ctx, "up");
                break;
            case Shortcut.SwapDown:
                this.engine.swapDirOrMoveFloat(ctx, "down");
                break;
            case Shortcut.SwapLeft:
                this.engine.swapDirOrMoveFloat(ctx, "left");
                break;
            case Shortcut.SwapRight:
                this.engine.swapDirOrMoveFloat(ctx, "right");
                break;
            case Shortcut.SetMaster:
                if (window)
                    this.engine.setMaster(window);
                break;
            case Shortcut.ToggleFloat:
                if (window)
                    this.engine.toggleFloat(window);
                break;
            case Shortcut.ToggleFloatAll:
                this.engine.floatAll(ctx, ctx.currentSurface);
                break;
            case Shortcut.NextLayout:
                this.engine.cycleLayout(ctx, 1);
                break;
            case Shortcut.PreviousLayout:
                this.engine.cycleLayout(ctx, -1);
                break;
            case Shortcut.SetLayout:
                if (typeof data === "string")
                    this.engine.setLayout(ctx, data);
                break;
        }
        this.engine.arrange(ctx);
    }
}
class TilingEngine {
    constructor() {
        this.layouts = new LayoutStore();
        this.windows = new WindowStore();
    }
    adjustLayout(basis) {
        let delta = basis.geometryDelta;
        if (delta === null)
            return;
        const srf = basis.surface;
        const layout = this.layouts.getCurrentLayout(srf);
        if (layout.adjust) {
            const area = srf.workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
            const tiles = this.windows.getVisibleTiles(srf);
            layout.adjust(area, tiles, basis, delta);
        }
    }
    resizeFloat(window, dir, step) {
        const srf = window.surface;
        const hStepSize = srf.workingArea.width * 0.05;
        const vStepSize = srf.workingArea.height * 0.05;
        let hStep, vStep;
        switch (dir) {
            case "east":
                (hStep = step), (vStep = 0);
                break;
            case "west":
                (hStep = -step), (vStep = 0);
                break;
            case "south":
                (hStep = 0), (vStep = step);
                break;
            case "north":
                (hStep = 0), (vStep = -step);
                break;
        }
        const geometry = window.actualGeometry;
        const width = geometry.width + hStepSize * hStep;
        const height = geometry.height + vStepSize * vStep;
        window.forceSetGeometry(new Rect(geometry.x, geometry.y, width, height));
    }
    resizeTile(basis, dir, step) {
        const srf = basis.surface;
        if (dir === "east") {
            const maxX = basis.geometry.maxX;
            const easternNeighbor = this.windows
                .getVisibleTiles(srf)
                .filter((tile) => tile.geometry.x >= maxX);
            if (easternNeighbor.length === 0) {
                dir = "west";
                step *= -1;
            }
        }
        else if (dir === "south") {
            const maxY = basis.geometry.maxY;
            const southernNeighbor = this.windows
                .getVisibleTiles(srf)
                .filter((tile) => tile.geometry.y >= maxY);
            if (southernNeighbor.length === 0) {
                dir = "north";
                step *= -1;
            }
        }
        const hStepSize = srf.workingArea.width * 0.03;
        const vStepSize = srf.workingArea.height * 0.03;
        let delta;
        switch (dir) {
            case "east":
                delta = new RectDelta(hStepSize * step, 0, 0, 0);
                break;
            case "west":
                delta = new RectDelta(0, hStepSize * step, 0, 0);
                break;
            case "south":
                delta = new RectDelta(0, 0, vStepSize * step, 0);
                break;
            case "north":
            default:
                delta = new RectDelta(0, 0, 0, vStepSize * step);
                break;
        }
        const layout = this.layouts.getCurrentLayout(srf);
        if (layout.adjust) {
            const area = srf.workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
            layout.adjust(area, this.windows.getVisibleTileables(srf), basis, delta);
        }
    }
    resizeWindow(window, dir, step) {
        const state = window.state;
        if (WindowClass.isFloatingState(state))
            this.resizeFloat(window, dir, step);
        else if (WindowClass.isTiledState(state))
            this.resizeTile(window, dir, step);
    }
    arrange(ctx) {
        debug(() => "arrange");
        ctx.screens.forEach((srf) => {
            this.arrangeScreen(ctx, srf);
        });
    }
    arrangeScreen(ctx, srf) {
        const layout = this.layouts.getCurrentLayout(srf);
        const workingArea = srf.workingArea;
        let tilingArea;
        if (CONFIG.monocleMaximize && layout instanceof MonocleLayout)
            tilingArea = workingArea;
        else
            tilingArea = workingArea.gap(CONFIG.screenGapLeft, CONFIG.screenGapRight, CONFIG.screenGapTop, CONFIG.screenGapBottom);
        const visibles = this.windows.getVisibleWindows(srf);
        debugObj(() => [
            "arrangeScreen",
            {
                layout,
                srf,
                visibles: visibles.length,
            },
        ]);
        visibles.forEach((window) => {
            if (window.state === WindowState.Undecided)
                window.state = window.shouldFloat
                    ? WindowState.Floating
                    : WindowState.Tiled;
        });
        const tileables = this.windows.getVisibleTileables(srf);
        if (CONFIG.maximizeSoleTile && tileables.length === 1) {
            tileables[0].state = WindowState.Maximized;
            tileables[0].geometry = workingArea;
        }
        else if (tileables.length > 0)
            layout.apply(new EngineContext(ctx, this), tileables, tilingArea);
        if (CONFIG.limitTileWidthRatio > 0 && !(layout instanceof MonocleLayout)) {
            const maxWidth = Math.floor(workingArea.height * CONFIG.limitTileWidthRatio);
            tileables
                .filter((tile) => tile.tiled && tile.geometry.width > maxWidth)
                .forEach((tile) => {
                const g = tile.geometry;
                tile.geometry = new Rect(g.x + Math.floor((g.width - maxWidth) / 2), g.y, maxWidth, g.height);
            });
        }
        visibles.forEach((window) => window.commit());
        debugObj(() => ["arrangeScreen/finished", { srf }]);
    }
    enforceSize(ctx, window) {
        if (window.tiled && !window.actualGeometry.equals(window.geometry))
            ctx.setTimeout(() => {
                if (window.tiled)
                    window.commit();
            }, 10);
    }
    manage(window) {
        if (!window.shouldIgnore) {
            window.state = WindowState.Undecided;
            if (CONFIG.newWindowPosition === 1)
                this.windows.unshift(window);
            else if (CONFIG.newWindowPosition === 2) {
                this.windows.beside_first(window);
            }
            else
                this.windows.push(window);
        }
    }
    unmanage(window) {
        this.windows.remove(window);
    }
    focusOrder(ctx, step) {
        const window = ctx.currentWindow;
        if (window === null) {
            const tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        const visibles = this.windows.getVisibleWindows(ctx.currentSurface);
        if (visibles.length === 0)
            return;
        const idx = visibles.indexOf(window);
        if (!window || idx < 0) {
            ctx.currentWindow = visibles[0];
            return;
        }
        const num = visibles.length;
        const newIndex = (idx + (step % num) + num) % num;
        ctx.currentWindow = visibles[newIndex];
    }
    focusDir(ctx, dir) {
        const window = ctx.currentWindow;
        if (window === null) {
            const tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        const neighbor = this.getNeighborByDirection(ctx, window, dir);
        if (neighbor)
            ctx.currentWindow = neighbor;
    }
    swapOrder(window, step) {
        const srf = window.surface;
        const visibles = this.windows.getVisibleWindows(srf);
        if (visibles.length < 2)
            return;
        const vsrc = visibles.indexOf(window);
        const vdst = wrapIndex(vsrc + step, visibles.length);
        const dstWin = visibles[vdst];
        this.windows.move(window, dstWin);
    }
    swapDirection(ctx, dir) {
        const window = ctx.currentWindow;
        if (window === null) {
            const tiles = this.windows.getVisibleTiles(ctx.currentSurface);
            if (tiles.length > 1)
                ctx.currentWindow = tiles[0];
            return;
        }
        const neighbor = this.getNeighborByDirection(ctx, window, dir);
        if (neighbor)
            this.windows.swap(window, neighbor);
    }
    moveFloat(window, dir) {
        const srf = window.surface;
        const hStepSize = srf.workingArea.width * 0.05;
        const vStepSize = srf.workingArea.height * 0.05;
        let hStep, vStep;
        switch (dir) {
            case "up":
                (hStep = 0), (vStep = -1);
                break;
            case "down":
                (hStep = 0), (vStep = 1);
                break;
            case "left":
                (hStep = -1), (vStep = 0);
                break;
            case "right":
                (hStep = 1), (vStep = 0);
                break;
        }
        const geometry = window.actualGeometry;
        const x = geometry.x + hStepSize * hStep;
        const y = geometry.y + vStepSize * vStep;
        window.forceSetGeometry(new Rect(x, y, geometry.width, geometry.height));
    }
    swapDirOrMoveFloat(ctx, dir) {
        const window = ctx.currentWindow;
        if (!window)
            return;
        const state = window.state;
        if (WindowClass.isFloatingState(state))
            this.moveFloat(window, dir);
        else if (WindowClass.isTiledState(state))
            this.swapDirection(ctx, dir);
    }
    toggleFloat(window) {
        window.state = !window.tileable ? WindowState.Tiled : WindowState.Floating;
    }
    floatAll(ctx, srf) {
        const windows = this.windows.getVisibleWindows(srf);
        const numFloats = windows.reduce((count, window) => {
            return window.state === WindowState.Floating ? count + 1 : count;
        }, 0);
        if (numFloats < windows.length / 2) {
            windows.forEach((window) => {
                window.floatGeometry = window.actualGeometry.gap(4, 4, 4, 4);
                window.state = WindowState.Floating;
            });
            ctx.showNotification("Float All");
        }
        else {
            windows.forEach((window) => {
                window.state = WindowState.Tiled;
            });
            ctx.showNotification("Tile All");
        }
    }
    setMaster(window) {
        this.windows.setMaster(window);
    }
    cycleLayout(ctx, step) {
        const layout = this.layouts.cycleLayout(ctx.currentSurface, step);
        if (layout)
            ctx.showNotification(layout.description);
    }
    setLayout(ctx, layoutClassID) {
        const layout = this.layouts.setLayout(ctx.currentSurface, layoutClassID);
        if (layout)
            ctx.showNotification(layout.description);
    }
    handleLayoutShortcut(ctx, input, data) {
        const layout = this.layouts.getCurrentLayout(ctx.currentSurface);
        if (layout.handleShortcut)
            return layout.handleShortcut(new EngineContext(ctx, this), input, data);
        return false;
    }
    getNeighborByDirection(ctx, basis, dir) {
        let vertical;
        let sign;
        switch (dir) {
            case "up":
                vertical = true;
                sign = -1;
                break;
            case "down":
                vertical = true;
                sign = 1;
                break;
            case "left":
                vertical = false;
                sign = -1;
                break;
            case "right":
                vertical = false;
                sign = 1;
                break;
            default:
                return null;
        }
        const candidates = this.windows
            .getVisibleTiles(ctx.currentSurface)
            .filter(vertical
            ? (tile) => tile.geometry.y * sign > basis.geometry.y * sign
            : (tile) => tile.geometry.x * sign > basis.geometry.x * sign)
            .filter(vertical
            ? (tile) => overlap(basis.geometry.x, basis.geometry.maxX, tile.geometry.x, tile.geometry.maxX)
            : (tile) => overlap(basis.geometry.y, basis.geometry.maxY, tile.geometry.y, tile.geometry.maxY));
        if (candidates.length === 0)
            return null;
        const min = sign *
            candidates.reduce(vertical
                ? (prevMin, tile) => Math.min(tile.geometry.y * sign, prevMin)
                : (prevMin, tile) => Math.min(tile.geometry.x * sign, prevMin), Infinity);
        const closest = candidates.filter(vertical
            ? (tile) => tile.geometry.y === min
            : (tile) => tile.geometry.x === min);
        return closest.sort((a, b) => b.timestamp - a.timestamp)[0];
    }
}
class EngineContext {
    get backend() {
        return this.drvctx.backend;
    }
    get currentWindow() {
        return this.drvctx.currentWindow;
    }
    set currentWindow(window) {
        this.drvctx.currentWindow = window;
    }
    constructor(drvctx, engine) {
        this.drvctx = drvctx;
        this.engine = engine;
    }
    setTimeout(func, timeout) {
        this.drvctx.setTimeout(func, timeout);
    }
    cycleFocus(step) {
        this.engine.focusOrder(this.drvctx, step);
    }
    moveWindow(window, target, after) {
        this.engine.windows.move(window, target, after);
    }
    moveWindowByWinId(window, targetId, after) {
        let target = this.engine.windows.getWindowById(targetId);
        if (target === null)
            return;
        this.engine.windows.moveNew(window, target, after);
    }
    getWindowById(id) {
        return this.engine.windows.getWindowById(id);
    }
    showNotification(text) {
        this.drvctx.showNotification(text);
    }
}
class LayoutStoreEntry {
    get currentLayout() {
        return this.loadLayout(this.currentID);
    }
    constructor(output_name, desktop_name) {
        let layouts = CONFIG.layoutOrder.map((layout) => layout.toLowerCase());
        let layouts_str = layouts.map((layout, i) => i + "." + layout + " ");
        print(`Krohnkite: Screen(output):${output_name}, Desktop(name):${desktop_name}, layouts: ${layouts_str}`);
        this.currentIndex = 0;
        this.currentID = CONFIG.layoutOrder[0];
        CONFIG.screenDefaultLayout.some((entry) => {
            let cfg = entry.split(":");
            let cfg_output = cfg[0];
            let cfg_desktop = cfg.length == 2 ? undefined : cfg[1];
            let cfg_screen_id_str = cfg.length == 2 ? cfg[1] : cfg[2];
            let cfg_screen_id = parseInt(cfg_screen_id_str);
            if (isNaN(cfg_screen_id)) {
                cfg_screen_id = layouts.indexOf(cfg_screen_id_str.toLowerCase());
                cfg_screen_id =
                    cfg_screen_id >= 0
                        ? cfg_screen_id
                        : layouts.indexOf(cfg_screen_id_str.toLowerCase() + "layout");
            }
            if ((output_name === cfg_output || cfg_output === "") &&
                (desktop_name === cfg_desktop || cfg_desktop === undefined) &&
                cfg_screen_id >= 0 &&
                cfg_screen_id < CONFIG.layoutOrder.length) {
                this.currentIndex = cfg_screen_id;
                this.currentID = CONFIG.layoutOrder[this.currentIndex];
                return true;
            }
        });
        this.layouts = {};
        this.previousID = this.currentID;
        this.loadLayout(this.currentID);
    }
    cycleLayout(step) {
        this.previousID = this.currentID;
        this.currentIndex =
            this.currentIndex !== null
                ? wrapIndex(this.currentIndex + step, CONFIG.layoutOrder.length)
                : 0;
        this.currentID = CONFIG.layoutOrder[this.currentIndex];
        return this.loadLayout(this.currentID);
    }
    setLayout(targetID) {
        let targetLayout = this.loadLayout(targetID);
        if (targetLayout instanceof MonocleLayout &&
            this.currentLayout instanceof MonocleLayout) {
            this.currentID = this.previousID;
            this.previousID = targetID;
            targetLayout = this.loadLayout(this.currentID);
        }
        else if (this.currentID !== targetID) {
            this.previousID = this.currentID;
            this.currentID = targetID;
        }
        this.updateCurrentIndex();
        return targetLayout;
    }
    updateCurrentIndex() {
        const idx = CONFIG.layoutOrder.indexOf(this.currentID);
        this.currentIndex = idx === -1 ? null : idx;
    }
    loadLayout(ID) {
        let layout = this.layouts[ID];
        if (!layout)
            layout = this.layouts[ID] = CONFIG.layoutFactories[ID]();
        return layout;
    }
}
class LayoutStore {
    constructor() {
        this.store = {};
    }
    getCurrentLayout(srf) {
        return srf.ignore
            ? FloatingLayout.instance
            : this.getEntry(srf.id).currentLayout;
    }
    cycleLayout(srf, step) {
        if (srf.ignore)
            return null;
        return this.getEntry(srf.id).cycleLayout(step);
    }
    setLayout(srf, layoutClassID) {
        if (srf.ignore)
            return null;
        return this.getEntry(srf.id).setLayout(layoutClassID);
    }
    getEntry(key) {
        if (!this.store[key]) {
            let i1 = key.indexOf("@");
            let i2 = key.indexOf("#");
            let key_without_activity = key.slice(0, i1 + 1) + key.slice(i2);
            if (i1 > 0 && i2 > 0 && i2 - i1 > 1 && this.store[key_without_activity]) {
                this.store[key] = this.store[key_without_activity];
                delete this.store[key_without_activity];
            }
            else {
                let output_name = key.slice(0, key.indexOf("@"));
                let desktop_name = i2 !== -1 ? key.slice(i2 + 1) : undefined;
                this.store[key] = new LayoutStoreEntry(output_name, desktop_name);
            }
        }
        return this.store[key];
    }
}
var WindowState;
(function (WindowState) {
    WindowState[WindowState["Unmanaged"] = 0] = "Unmanaged";
    WindowState[WindowState["NativeFullscreen"] = 1] = "NativeFullscreen";
    WindowState[WindowState["NativeMaximized"] = 2] = "NativeMaximized";
    WindowState[WindowState["Floating"] = 3] = "Floating";
    WindowState[WindowState["Maximized"] = 4] = "Maximized";
    WindowState[WindowState["Tiled"] = 5] = "Tiled";
    WindowState[WindowState["TiledAfloat"] = 6] = "TiledAfloat";
    WindowState[WindowState["Undecided"] = 7] = "Undecided";
    WindowState[WindowState["Dragging"] = 8] = "Dragging";
})(WindowState || (WindowState = {}));
class WindowClass {
    static isTileableState(state) {
        return (state === WindowState.Dragging ||
            state === WindowState.Tiled ||
            state === WindowState.Maximized ||
            state === WindowState.TiledAfloat);
    }
    static isTiledState(state) {
        return state === WindowState.Tiled || state === WindowState.Maximized;
    }
    static isFloatingState(state) {
        return state === WindowState.Floating || state === WindowState.TiledAfloat;
    }
    get actualGeometry() {
        return this.window.geometry;
    }
    get shouldFloat() {
        return this.window.shouldFloat;
    }
    get shouldIgnore() {
        return this.window.shouldIgnore;
    }
    get tileable() {
        return WindowClass.isTileableState(this.state);
    }
    get tiled() {
        return WindowClass.isTiledState(this.state);
    }
    get floating() {
        return WindowClass.isFloatingState(this.state);
    }
    get geometryDelta() {
        if (this.geometry === this.actualGeometry)
            return null;
        return RectDelta.fromRects(this.geometry, this.actualGeometry);
    }
    get state() {
        if (this.window.fullScreen)
            return WindowState.NativeFullscreen;
        if (this.window.maximized)
            return WindowState.NativeMaximized;
        return this.internalState;
    }
    set state(value) {
        const state = this.state;
        if (state === value || state === WindowState.Dragging)
            return;
        if ((state === WindowState.Unmanaged || WindowClass.isTileableState(state)) &&
            WindowClass.isFloatingState(value))
            this.shouldCommitFloat = true;
        else if (WindowClass.isFloatingState(state) &&
            WindowClass.isTileableState(value))
            this.floatGeometry = this.actualGeometry;
        this.internalState = value;
    }
    setDraggingState() {
        this.internalState = WindowState.Dragging;
    }
    removeDraggingState(value) {
        this.internalState = value;
    }
    get surface() {
        return this.window.surface;
    }
    set surface(srf) {
        this.window.surface = srf;
    }
    get weight() {
        const srfID = this.window.surface.id;
        const weight = this.weightMap[srfID];
        if (weight === undefined) {
            this.weightMap[srfID] = 1.0;
            return 1.0;
        }
        return weight;
    }
    set weight(value) {
        const srfID = this.window.surface.id;
        this.weightMap[srfID] = value;
    }
    constructor(window) {
        this.id = window.id;
        this.window = window;
        this.floatGeometry = window.geometry;
        this.geometry = window.geometry;
        this.timestamp = 0;
        this.internalState = WindowState.Unmanaged;
        this.shouldCommitFloat = this.shouldFloat;
        this.weightMap = {};
    }
    commit() {
        const state = this.state;
        debugObj(() => ["Window#commit", { state: WindowState[state] }]);
        switch (state) {
            case WindowState.Dragging:
                break;
            case WindowState.NativeMaximized:
                this.window.commit(undefined, undefined, false);
                break;
            case WindowState.NativeFullscreen:
                this.window.commit(undefined, undefined, undefined);
                break;
            case WindowState.Floating:
                if (!this.shouldCommitFloat)
                    break;
                this.window.commit(this.floatGeometry, false, CONFIG.keepFloatAbove);
                this.shouldCommitFloat = false;
                break;
            case WindowState.Maximized:
                this.window.commit(this.geometry, true, false);
                break;
            case WindowState.Tiled:
                this.window.commit(this.geometry, CONFIG.noTileBorder, false);
                break;
            case WindowState.TiledAfloat:
                if (!this.shouldCommitFloat)
                    break;
                this.window.commit(this.floatGeometry, false, CONFIG.keepFloatAbove);
                this.shouldCommitFloat = false;
                break;
        }
    }
    forceSetGeometry(geometry) {
        this.window.commit(geometry);
    }
    visible(srf) {
        return this.window.visible(srf);
    }
    get minimized() {
        return this.window.minimized;
    }
    toString() {
        return "Window(" + String(this.window) + ")";
    }
}
class WindowStore {
    constructor(windows) {
        this.list = windows || [];
    }
    move(srcWin, destWin, after) {
        const srcIdx = this.list.indexOf(srcWin);
        const destIdx = this.list.indexOf(destWin);
        if (srcIdx === -1 || destIdx === -1)
            return;
        this.list.splice(srcIdx, 1);
        this.list.splice(after ? destIdx + 1 : destIdx, 0, srcWin);
    }
    moveNew(srcWin, destWin, after) {
        const srcIdx = this.list.indexOf(srcWin);
        const destIdx = this.list.indexOf(destWin);
        if (srcIdx === -1 || destIdx === -1)
            return;
        if (srcIdx > destIdx) {
            this.list.splice(srcIdx, 1);
            this.list.splice(after ? destIdx + 1 : destIdx, 0, srcWin);
        }
        else if (destIdx > srcIdx) {
            this.list.splice(srcIdx, 1);
            this.list.splice(after ? destIdx : destIdx - 1, 0, srcWin);
        }
    }
    getWindowById(id) {
        let idx = this.list.map((w) => w.id).indexOf(id);
        return idx < 0 ? null : this.list[idx];
    }
    setMaster(window) {
        const idx = this.list.indexOf(window);
        if (idx === -1)
            return;
        this.list.splice(idx, 1);
        this.list.splice(0, 0, window);
    }
    swap(alpha, beta) {
        const alphaIndex = this.list.indexOf(alpha);
        const betaIndex = this.list.indexOf(beta);
        if (alphaIndex < 0 || betaIndex < 0)
            return;
        this.list[alphaIndex] = beta;
        this.list[betaIndex] = alpha;
    }
    get length() {
        return this.list.length;
    }
    at(idx) {
        return this.list[idx];
    }
    indexOf(window) {
        return this.list.indexOf(window);
    }
    push(window) {
        this.list.push(window);
    }
    beside_first(window) {
        this.list.splice(1, 0, window);
    }
    remove(window) {
        const idx = this.list.indexOf(window);
        if (idx >= 0)
            this.list.splice(idx, 1);
    }
    unshift(window) {
        this.list.unshift(window);
    }
    getVisibleWindows(srf) {
        return this.list.filter((win) => win.visible(srf));
    }
    getVisibleTiles(srf) {
        return this.list.filter((win) => win.tiled && win.visible(srf));
    }
    getVisibleTileables(srf) {
        return this.list.filter((win) => win.tileable && win.visible(srf));
    }
}
class BTreeLayout {
    get description() {
        return "BTree";
    }
    constructor() {
        this.classID = BTreeLayout.id;
        this.parts = new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
        this.parts.angle = 0;
        this.parts.gap = CONFIG.tileLayoutGap;
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        this.create_parts(tileables.length);
        let rectangles = this.parts.apply(area, tileables);
        rectangles.forEach((geometry, i) => {
            tileables[i].geometry = geometry;
        });
    }
    create_parts(tiles_len) {
        let head = this.get_head();
        head.angle = 0;
        head.gap = CONFIG.tileLayoutGap;
        if (tiles_len > 2) {
            let level = Math.ceil(Math.log(tiles_len) * 1.442695);
            let level_capacity = Math.pow(2, (level - 1));
            let half_level_capacity = Math.pow(2, (level - 2));
            if (tiles_len > level_capacity + half_level_capacity) {
                head.primarySize = tiles_len - level_capacity;
            }
            else {
                head.primarySize = half_level_capacity;
            }
            this.build_binary_tree(head, level, 2, tiles_len);
        }
        this.parts = head;
    }
    build_binary_tree(head, max_level, current_level, tiles_len) {
        if (current_level <= max_level) {
            if (head.primarySize > 1) {
                let primary = this.get_head();
                primary.primarySize = Math.floor(head.primarySize / 2);
                primary.gap = CONFIG.tileLayoutGap;
                primary.angle = current_level % 2 ? 0 : 90;
                head.primary = primary;
                this.build_binary_tree(primary, max_level, current_level + 1, head.primarySize);
            }
            if (tiles_len - head.primarySize > 1) {
                let secondary = this.get_head();
                secondary.primarySize = Math.floor((tiles_len - head.primarySize) / 2);
                secondary.gap = CONFIG.tileLayoutGap;
                secondary.angle = current_level % 2 ? 0 : 90;
                head.secondary = secondary;
                this.build_binary_tree(secondary, max_level, current_level + 1, tiles_len - head.primarySize);
            }
        }
    }
    get_head() {
        return new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
    }
    clone() {
        const other = new StackedLayout();
        return other;
    }
    toString() {
        return "BTreeLayout()";
    }
}
BTreeLayout.id = "BTreeLayout";
var CascadeDirection;
(function (CascadeDirection) {
    CascadeDirection[CascadeDirection["NorthWest"] = 0] = "NorthWest";
    CascadeDirection[CascadeDirection["North"] = 1] = "North";
    CascadeDirection[CascadeDirection["NorthEast"] = 2] = "NorthEast";
    CascadeDirection[CascadeDirection["East"] = 3] = "East";
    CascadeDirection[CascadeDirection["SouthEast"] = 4] = "SouthEast";
    CascadeDirection[CascadeDirection["South"] = 5] = "South";
    CascadeDirection[CascadeDirection["SouthWest"] = 6] = "SouthWest";
    CascadeDirection[CascadeDirection["West"] = 7] = "West";
})(CascadeDirection || (CascadeDirection = {}));
class CascadeLayout {
    static decomposeDirection(dir) {
        switch (dir) {
            case CascadeDirection.NorthWest:
                return [-1, -1];
            case CascadeDirection.North:
                return [-1, 0];
            case CascadeDirection.NorthEast:
                return [-1, 1];
            case CascadeDirection.East:
                return [0, 1];
            case CascadeDirection.SouthEast:
                return [1, 1];
            case CascadeDirection.South:
                return [1, 0];
            case CascadeDirection.SouthWest:
                return [1, -1];
            case CascadeDirection.West:
                return [0, -1];
        }
    }
    get description() {
        return "Cascade [" + CascadeDirection[this.dir] + "]";
    }
    constructor(dir = CascadeDirection.SouthEast) {
        this.dir = dir;
        this.classID = CascadeLayout.id;
    }
    apply(ctx, tileables, area) {
        const [vertStep, horzStep] = CascadeLayout.decomposeDirection(this.dir);
        const stepSize = 25;
        const windowWidth = horzStep !== 0
            ? area.width - stepSize * (tileables.length - 1)
            : area.width;
        const windowHeight = vertStep !== 0
            ? area.height - stepSize * (tileables.length - 1)
            : area.height;
        const baseX = horzStep >= 0 ? area.x : area.maxX - windowWidth;
        const baseY = vertStep >= 0 ? area.y : area.maxY - windowHeight;
        let x = baseX, y = baseY;
        tileables.forEach((tile) => {
            tile.state = WindowState.Tiled;
            tile.geometry = new Rect(x, y, windowWidth, windowHeight);
            x += horzStep * stepSize;
            y += vertStep * stepSize;
        });
    }
    clone() {
        return new CascadeLayout(this.dir);
    }
    handleShortcut(ctx, input, data) {
        switch (input) {
            case Shortcut.Increase:
                this.dir = (this.dir + 1 + 8) % 8;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Decrease:
                this.dir = (this.dir - 1 + 8) % 8;
                ctx.showNotification(this.description);
                break;
            default:
                return false;
        }
        return true;
    }
}
CascadeLayout.id = "CascadeLayout";
class ColumnLayout {
    get description() {
        return "Column";
    }
    toString() {
        let s = `ColumnLayout${this.windowIds.size}:`;
        this.windowIds.forEach((id) => (s = s + id + ","));
        return s;
    }
    constructor() {
        this.classID = ColumnLayout.id;
        this.position = "single";
        this.weight = 1.0;
        this.parts = new RotateLayoutPart(new StackLayoutPart());
        this.parts.inner.gap = CONFIG.tileLayoutGap;
        this.windowIds = new Set();
        this.renderedWindowsIds = [];
        this.renderedWindowsRects = [];
        this.numberFloatedOrMinimized = 0;
        this.timestamp = 0;
    }
    get size() {
        return this.windowIds.size - this.numberFloatedOrMinimized;
    }
    set isHorizontal(value) {
        if (value)
            this.parts.angle = 270;
        else
            this.parts.angle = 0;
    }
    isEmpty() {
        return this.windowIds.size === this.numberFloatedOrMinimized;
    }
    apply(ctx, tileables, area) {
        this.renderedWindowsIds = [];
        let columnTileables = tileables.filter((w) => {
            if (this.windowIds.has(w.id)) {
                this.renderedWindowsIds.push(w.id);
                return true;
            }
        });
        this.renderedWindowsRects = [];
        this.parts.apply(area, columnTileables).forEach((geometry, i) => {
            columnTileables[i].geometry = geometry;
            this.renderedWindowsRects.push(geometry);
        });
    }
    getUpperWindowId(id) {
        let winId = this.renderedWindowsIds.indexOf(id);
        if (winId < 1)
            return null;
        return this.renderedWindowsIds[winId - 1];
    }
    getLowerWindowId(id) {
        let winId = this.renderedWindowsIds.indexOf(id);
        if (winId < 0 || winId === this.renderedWindowsIds.length - 1)
            return null;
        return this.renderedWindowsIds[winId + 1];
    }
    getWindowIdOnRight(x) {
        for (let i = 0; i < this.renderedWindowsIds.length; i++) {
            if (x < this.renderedWindowsRects[i].center[0] + 10)
                return this.renderedWindowsIds[i];
        }
        return null;
    }
    getWindowIdOnTop(y) {
        for (let i = 0; i < this.renderedWindowsIds.length; i++) {
            if (y < this.renderedWindowsRects[i].center[1] + 10)
                return this.renderedWindowsIds[i];
        }
        return null;
    }
    adjust(area, tiles, basis, delta) {
        let columnTiles = tiles.filter((t) => this.windowIds.has(t.id));
        this.parts.adjust(area, columnTiles, basis, delta);
    }
    actualizeWindowIds(ctx, ids) {
        let window;
        let floatedOrMinimized = 0;
        this.windowIds = new Set([...this.windowIds].filter((id) => {
            window = ctx.getWindowById(id);
            if (ids.has(id))
                return true;
            else if (window !== null && (window.minimized || window.floating)) {
                floatedOrMinimized += 1;
                return true;
            }
            return false;
        }));
        this.numberFloatedOrMinimized = floatedOrMinimized;
    }
}
ColumnLayout.id = "Column";
class ColumnsLayout {
    get description() {
        return "Columns";
    }
    get columns() {
        return this._columns;
    }
    constructor() {
        this.classID = ColumnsLayout.id;
        this.parts = [new ColumnLayout()];
        this._columns = [];
        this.direction = new windRose(CONFIG.columnsLayoutInitialAngle);
    }
    adjust(area, tiles, basis, delta) {
        let columnId = this.getColumnId(basis);
        if (columnId === null)
            return;
        let isReverse = this.direction.east || this.direction.south;
        let columnsLength = this.columns.length;
        if (((this.direction.east || this.direction.west) &&
            (delta.east !== 0 || delta.west !== 0)) ||
            ((this.direction.north || this.direction.south) &&
                (delta.north !== 0 || delta.south !== 0))) {
            let oldWeights;
            if (isReverse) {
                oldWeights = this.columns
                    .slice(0)
                    .reverse()
                    .map((column) => column.weight);
            }
            else {
                oldWeights = this.columns.map((column) => column.weight);
            }
            const weights = LayoutUtils.adjustAreaWeights(area, oldWeights, CONFIG.tileLayoutGap, isReverse ? columnsLength - 1 - columnId : columnId, delta, this.direction.east || this.direction.west);
            weights.forEach((weight, i) => {
                this.columns[isReverse ? columnsLength - 1 - i : i].weight =
                    weight * columnsLength;
            });
        }
        if (((delta.north !== 0 || delta.south !== 0) &&
            (this.direction.east || this.direction.west)) ||
            ((delta.east !== 0 || delta.west !== 0) &&
                (this.direction.north || this.direction.south))) {
            this.columns[columnId].adjust(area, tiles, basis, delta);
        }
    }
    apply(ctx, tileables, area) {
        this.arrangeTileables(ctx, tileables);
        if (this.columns.length === 0)
            return;
        let weights;
        if (this.direction.east || this.direction.south) {
            weights = this.columns
                .slice(0)
                .reverse()
                .map((tile) => tile.weight);
        }
        else {
            weights = this.columns.map((tile) => tile.weight);
        }
        const rects = LayoutUtils.splitAreaWeighted(area, weights, CONFIG.tileLayoutGap, this.direction.east || this.direction.west);
        if (this.direction.east || this.direction.south) {
            let i = 0;
            for (var idx = this.columns.length - 1; idx >= 0; idx--) {
                this.columns[idx].isHorizontal = this.direction.south;
                this.columns[idx].apply(ctx, tileables, rects[i]);
                i++;
            }
        }
        else {
            for (var idx = 0; idx < this.columns.length; idx++) {
                this.columns[idx].isHorizontal = this.direction.north;
                this.columns[idx].apply(ctx, tileables, rects[idx]);
            }
        }
    }
    drag(ctx, draggingRect, window, workingArea) {
        const activationPoint = draggingRect.activationPoint;
        const middlePoint = draggingRect.center;
        if (this.columns.length === 0 ||
            (this.columns.length === 1 && this.columns[0].windowIds.size === 1))
            return false;
        let columnId = this.getColumnId(window);
        let windowId = window.id;
        if (((this.direction.north && workingArea.isTopZone(activationPoint)) ||
            (this.direction.south && workingArea.isBottomZone(middlePoint)) ||
            (this.direction.west && workingArea.isLeftZone(activationPoint)) ||
            (this.direction.east && workingArea.isRightZone(activationPoint))) &&
            !(this.columns[0].windowIds.size === 1 &&
                this.columns[0].windowIds.has(windowId))) {
            if (columnId !== null)
                this.columns[columnId].windowIds.delete(windowId);
            const column = this.insertColumn(true);
            column.windowIds.add(windowId);
            return true;
        }
        if (((this.direction.north && workingArea.isBottomZone(middlePoint)) ||
            (this.direction.south && workingArea.isTopZone(activationPoint)) ||
            (this.direction.west && workingArea.isRightZone(activationPoint)) ||
            (this.direction.east && workingArea.isLeftZone(activationPoint))) &&
            !(this.columns[this.columns.length - 1].windowIds.size === 1 &&
                this.columns[this.columns.length - 1].windowIds.has(windowId))) {
            if (columnId !== null)
                this.columns[columnId].windowIds.delete(windowId);
            const column = this.insertColumn(false);
            column.windowIds.add(windowId);
            return true;
        }
        for (let colIdx = 0; colIdx < this.columns.length; colIdx++) {
            const column = this.columns[colIdx];
            for (let i = 0; i < column.renderedWindowsRects.length; i++) {
                const renderedRect = column.renderedWindowsRects[i];
                if ((this.direction.west &&
                    renderedRect.includesPoint(activationPoint, 0)) ||
                    (this.direction.north &&
                        renderedRect.includesPoint(activationPoint, 2)) ||
                    (this.direction.east &&
                        renderedRect.includesPoint(activationPoint, 0)) ||
                    (this.direction.south &&
                        renderedRect.includesPoint(activationPoint, 2))) {
                    if (column.renderedWindowsIds[i] === windowId)
                        return false;
                    if (i > 0 && column.renderedWindowsIds[i - 1] === windowId)
                        return false;
                    const renderedId = column.renderedWindowsIds[i];
                    if (columnId !== null && columnId !== colIdx)
                        this.columns[columnId].windowIds.delete(windowId);
                    column.windowIds.add(windowId);
                    ctx.moveWindowByWinId(window, renderedId);
                    return true;
                }
                if ((this.direction.west &&
                    renderedRect.includesPoint(activationPoint, 1)) ||
                    (this.direction.north &&
                        renderedRect.includesPoint(activationPoint, 3)) ||
                    (this.direction.east &&
                        renderedRect.includesPoint(activationPoint, 1)) ||
                    (this.direction.south &&
                        renderedRect.includesPoint(activationPoint, 3))) {
                    if (column.renderedWindowsIds[i] === windowId)
                        return false;
                    if (i < column.renderedWindowsIds.length - 1 &&
                        column.renderedWindowsIds[i + 1] === windowId)
                        return false;
                    const renderedId = column.renderedWindowsIds[i];
                    if (columnId !== null && columnId !== colIdx)
                        this.columns[columnId].windowIds.delete(windowId);
                    column.windowIds.add(windowId);
                    ctx.moveWindowByWinId(window, renderedId, true);
                    return true;
                }
            }
        }
        return false;
    }
    arrangeTileables(ctx, tileables) {
        let latestTimestamp = 0;
        let partId = null;
        let newWindows = [];
        let tileableIds = new Set();
        let currentColumnId = 0;
        tileables.forEach((tileable) => {
            tileable.state = WindowState.Tiled;
            partId = this.getPartsId(tileable);
            if (partId !== null) {
                if (this.parts[partId].timestamp < tileable.timestamp) {
                    this.parts[partId].timestamp = tileable.timestamp;
                }
                if (this.parts[partId].timestamp > latestTimestamp) {
                    latestTimestamp = tileable.timestamp;
                    currentColumnId = partId;
                }
            }
            else {
                newWindows.push(tileable.id);
            }
            tileableIds.add(tileable.id);
        });
        if (CONFIG.columnsBalanced) {
            for (var [_, id] of newWindows.entries()) {
                let minSizeColumn = this.parts.reduce((prev, curr) => {
                    return prev.size < curr.size ? prev : curr;
                });
                minSizeColumn.windowIds.add(id);
            }
        }
        else {
            this.parts[currentColumnId].windowIds = new Set([
                ...this.parts[currentColumnId].windowIds,
                ...newWindows,
            ]);
        }
        this.parts.forEach((column) => {
            column.actualizeWindowIds(ctx, tileableIds);
        });
        this.parts = this.parts.filter((column) => column.windowIds.size !== 0);
        if (this.parts.length === 0)
            this.insertColumn(true);
        this.applyColumnsPosition();
    }
    getColumnId(t) {
        for (var i = 0; i < this.columns.length; i++) {
            if (this.columns[i].windowIds.has(t.id))
                return i;
        }
        return null;
    }
    getPartsId(t) {
        for (var i = 0; i < this.parts.length; i++) {
            if (this.parts[i].windowIds.has(t.id))
                return i;
        }
        return null;
    }
    getCurrentColumnId(currentWindowId) {
        if (currentWindowId !== null) {
            for (const [i, column] of this.columns.entries()) {
                if (column.windowIds.has(currentWindowId))
                    return i;
            }
        }
        return null;
    }
    applyColumnsPosition() {
        this._columns = this.parts.filter((column) => !column.isEmpty());
        const columnsLength = this.columns.length;
        if (columnsLength === 1) {
            this.columns[0].position = "single";
        }
        else if (columnsLength > 1) {
            this.columns[0].position = "left";
            this.columns[columnsLength - 1].position = "right";
            for (let i = 1; i < columnsLength - 1; i++) {
                this.columns[i].position = "middle";
            }
        }
    }
    toColumnWithBiggerIndex(ctx) {
        const currentWindow = ctx.currentWindow;
        const currentWindowId = currentWindow !== null ? currentWindow.id : null;
        const activeColumnId = this.getCurrentColumnId(currentWindowId);
        if (currentWindow === null ||
            currentWindowId === null ||
            activeColumnId === null ||
            (this.columns[activeColumnId].size < 2 &&
                (this.columns[activeColumnId].position === "right" ||
                    this.columns[activeColumnId].position === "single")))
            return false;
        let targetColumn;
        const column = this.columns[activeColumnId];
        const center = column.renderedWindowsRects[column.renderedWindowsIds.indexOf(currentWindowId)].center;
        column.windowIds.delete(currentWindowId);
        if (column.position === "single" || column.position === "right") {
            targetColumn = this.insertColumn(false);
            targetColumn.windowIds.add(currentWindowId);
        }
        else {
            targetColumn = this.columns[activeColumnId + 1];
            targetColumn.windowIds.add(currentWindowId);
        }
        let idOnTarget;
        if (this.direction.north || this.direction.south)
            idOnTarget = targetColumn.getWindowIdOnRight(center[0]);
        else
            idOnTarget = targetColumn.getWindowIdOnTop(center[1]);
        if (idOnTarget !== null)
            ctx.moveWindowByWinId(currentWindow, idOnTarget);
        else {
            const targetId = targetColumn.renderedWindowsIds[targetColumn.renderedWindowsIds.length - 1];
            ctx.moveWindowByWinId(currentWindow, targetId);
        }
        this.applyColumnsPosition();
        return true;
    }
    toColumnWithSmallerIndex(ctx) {
        const currentWindow = ctx.currentWindow;
        const currentWindowId = currentWindow !== null ? currentWindow.id : null;
        const activeColumnId = this.getCurrentColumnId(currentWindowId);
        if (currentWindow === null ||
            currentWindowId === null ||
            activeColumnId === null ||
            (this.columns[activeColumnId].windowIds.size < 2 &&
                (this.columns[activeColumnId].position === "left" ||
                    this.columns[activeColumnId].position === "single")))
            return false;
        let targetColumn;
        const column = this.columns[activeColumnId];
        const center = column.renderedWindowsRects[column.renderedWindowsIds.indexOf(currentWindowId)].center;
        column.windowIds.delete(currentWindowId);
        if (column.position === "single" || column.position === "left") {
            targetColumn = this.insertColumn(true);
            targetColumn.windowIds.add(currentWindowId);
        }
        else {
            targetColumn = this.columns[activeColumnId - 1];
            targetColumn.windowIds.add(currentWindowId);
        }
        let idOnTarget;
        if (this.direction.north || this.direction.south)
            idOnTarget = targetColumn.getWindowIdOnRight(center[0]);
        else
            idOnTarget = targetColumn.getWindowIdOnTop(center[1]);
        if (idOnTarget !== null)
            ctx.moveWindowByWinId(currentWindow, idOnTarget);
        else {
            const targetId = targetColumn.renderedWindowsIds[targetColumn.renderedWindowsIds.length - 1];
            ctx.moveWindowByWinId(currentWindow, targetId);
        }
        this.applyColumnsPosition();
        return true;
    }
    toUpOrLeft(ctx) {
        let currentWindow = ctx.currentWindow;
        let currentWindowId = currentWindow !== null ? currentWindow.id : null;
        let activeColumnId = this.getCurrentColumnId(currentWindowId);
        if (currentWindow === null ||
            currentWindowId === null ||
            activeColumnId === null ||
            this.columns[activeColumnId].windowIds.size < 2)
            return false;
        let upperWinId = this.columns[activeColumnId].getUpperWindowId(currentWindowId);
        if (upperWinId === null)
            return false;
        ctx.moveWindowByWinId(currentWindow, upperWinId);
        return true;
    }
    toBottomOrRight(ctx) {
        let currentWindow = ctx.currentWindow;
        let currentWindowId = currentWindow !== null ? currentWindow.id : null;
        let activeColumnId = this.getCurrentColumnId(currentWindowId);
        if (currentWindow === null ||
            currentWindowId === null ||
            activeColumnId === null ||
            this.columns[activeColumnId].windowIds.size < 2)
            return false;
        let lowerWinId = this.columns[activeColumnId].getLowerWindowId(currentWindowId);
        if (lowerWinId === null)
            return false;
        ctx.moveWindowByWinId(currentWindow, lowerWinId, true);
        return true;
    }
    showDirection(ctx) {
        let notification;
        if (this.direction.east)
            notification = "vertical ⟰";
        else if (this.direction.north)
            notification = "horizontal ⭆";
        else if (this.direction.west)
            notification = "vertical ⟱";
        else if (this.direction.south)
            notification = "horizontal ⭅";
        else
            notification = "";
        ctx.showNotification(notification);
    }
    handleShortcut(ctx, input) {
        let isApply = false;
        switch (input) {
            case Shortcut.SwapLeft:
                if (this.direction.north || this.direction.south) {
                    isApply = this.toUpOrLeft(ctx);
                }
                else if (this.direction.east) {
                    isApply = this.toColumnWithBiggerIndex(ctx);
                }
                else
                    isApply = this.toColumnWithSmallerIndex(ctx);
                break;
            case Shortcut.SwapRight:
                if (this.direction.north || this.direction.south) {
                    isApply = this.toBottomOrRight(ctx);
                }
                else if (this.direction.east) {
                    isApply = this.toColumnWithSmallerIndex(ctx);
                }
                else
                    isApply = this.toColumnWithBiggerIndex(ctx);
                break;
            case Shortcut.SwapUp:
                if (this.direction.north) {
                    isApply = this.toColumnWithSmallerIndex(ctx);
                }
                else if (this.direction.south) {
                    isApply = this.toColumnWithBiggerIndex(ctx);
                }
                else
                    isApply = this.toUpOrLeft(ctx);
                break;
            case Shortcut.SwapDown:
                if (this.direction.north) {
                    isApply = this.toColumnWithBiggerIndex(ctx);
                }
                else if (this.direction.south) {
                    isApply = this.toColumnWithSmallerIndex(ctx);
                }
                else
                    isApply = this.toBottomOrRight(ctx);
                break;
            case Shortcut.Rotate:
                this.direction.cwRotation();
                this.showDirection(ctx);
                isApply = true;
                break;
            case Shortcut.RotatePart:
                this.direction.ccwRotation();
                this.showDirection(ctx);
                isApply = true;
                break;
            default:
                return false;
        }
        return isApply;
    }
    insertColumn(onTop) {
        let column = new ColumnLayout();
        this.parts.splice(onTop ? 0 : this.parts.length, 0, column);
        return column;
    }
}
ColumnsLayout.id = "Columns";
class FloatingLayout {
    constructor() {
        this.classID = FloatingLayout.id;
        this.description = "Floating";
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.TiledAfloat));
    }
    clone() {
        return this;
    }
    toString() {
        return "FloatingLayout()";
    }
}
FloatingLayout.id = "FloatingLayout ";
FloatingLayout.instance = new FloatingLayout();
class FillLayoutPart {
    adjust(area, tiles, basis, delta) {
        return delta;
    }
    apply(area, tiles) {
        return tiles.map((tile) => {
            return area;
        });
    }
    toString() {
        return `FillLayoutPart`;
    }
}
class HalfSplitLayoutPart {
    get horizontal() {
        return this.angle === 0 || this.angle === 180;
    }
    get reversed() {
        return this.angle === 180 || this.angle === 270;
    }
    constructor(primary, secondary) {
        this.primary = primary;
        this.secondary = secondary;
        this.angle = 0;
        this.gap = 0;
        this.primarySize = 1;
        this.ratio = 0.5;
    }
    adjust(area, tiles, basis, delta) {
        const basisIndex = tiles.indexOf(basis);
        if (basisIndex < 0)
            return delta;
        if (tiles.length <= this.primarySize) {
            return this.primary.adjust(area, tiles, basis, delta);
        }
        else if (this.primarySize === 0) {
            return this.secondary.adjust(area, tiles, basis, delta);
        }
        else {
            const targetIndex = basisIndex < this.primarySize ? 0 : 1;
            if (targetIndex === 0) {
                delta = this.primary.adjust(area, tiles.slice(0, this.primarySize), basis, delta);
            }
            else {
                delta = this.secondary.adjust(area, tiles.slice(this.primarySize), basis, delta);
            }
            this.ratio = LayoutUtils.adjustAreaHalfWeights(area, this.reversed ? 1 - this.ratio : this.ratio, this.gap, this.reversed ? 1 - targetIndex : targetIndex, delta, this.horizontal);
            if (this.reversed)
                this.ratio = 1 - this.ratio;
            switch (this.angle * 10 + targetIndex + 1) {
                case 1:
                case 1802:
                    return new RectDelta(0, delta.west, delta.south, delta.north);
                case 2:
                case 1801:
                    return new RectDelta(delta.east, 0, delta.south, delta.north);
                case 901:
                case 2702:
                    return new RectDelta(delta.east, delta.west, 0, delta.north);
                case 902:
                case 2701:
                    return new RectDelta(delta.east, delta.west, delta.south, 0);
            }
            return delta;
        }
    }
    toString() {
        return `<HalfSplitLayout: angle:${this.angle},ratio:${this.ratio},pr_size:${this.primarySize}.<<<Primary:${this.primary}---Secondary:${this.secondary}>>>`;
    }
    apply(area, tiles) {
        if (tiles.length <= this.primarySize) {
            return this.primary.apply(area, tiles);
        }
        else if (this.primarySize === 0) {
            return this.secondary.apply(area, tiles);
        }
        else {
            const reversed = this.reversed;
            const ratio = reversed ? 1 - this.ratio : this.ratio;
            const [area1, area2] = LayoutUtils.splitAreaHalfWeighted(area, ratio, this.gap, this.horizontal);
            const result1 = this.primary.apply(reversed ? area2 : area1, tiles.slice(0, this.primarySize));
            const result2 = this.secondary.apply(reversed ? area1 : area2, tiles.slice(this.primarySize));
            return result1.concat(result2);
        }
    }
}
class StackLayoutPart {
    constructor() {
        this.gap = 0;
    }
    adjust(area, tiles, basis, delta) {
        const weights = LayoutUtils.adjustAreaWeights(area, tiles.map((tile) => tile.weight), CONFIG.tileLayoutGap, tiles.indexOf(basis), delta, false);
        weights.forEach((weight, i) => {
            tiles[i].weight = weight * tiles.length;
        });
        const idx = tiles.indexOf(basis);
        return new RectDelta(delta.east, delta.west, idx === tiles.length - 1 ? delta.south : 0, idx === 0 ? delta.north : 0);
    }
    apply(area, tiles) {
        const weights = tiles.map((tile) => tile.weight);
        return LayoutUtils.splitAreaWeighted(area, weights, this.gap);
    }
}
class RotateLayoutPart {
    constructor(inner, angle = 0) {
        this.inner = inner;
        this.angle = angle;
    }
    adjust(area, tiles, basis, delta) {
        switch (this.angle) {
            case 0:
                break;
            case 90:
                area = new Rect(area.y, area.x, area.height, area.width);
                delta = new RectDelta(delta.south, delta.north, delta.east, delta.west);
                break;
            case 180:
                delta = new RectDelta(delta.west, delta.east, delta.south, delta.north);
                break;
            case 270:
                area = new Rect(area.y, area.x, area.height, area.width);
                delta = new RectDelta(delta.north, delta.south, delta.east, delta.west);
                break;
        }
        delta = this.inner.adjust(area, tiles, basis, delta);
        switch (this.angle) {
            case 0:
                delta = delta;
                break;
            case 90:
                delta = new RectDelta(delta.south, delta.north, delta.east, delta.west);
                break;
            case 180:
                delta = new RectDelta(delta.west, delta.east, delta.south, delta.north);
                break;
            case 270:
                delta = new RectDelta(delta.north, delta.south, delta.east, delta.west);
                break;
        }
        return delta;
    }
    apply(area, tiles) {
        switch (this.angle) {
            case 0:
                break;
            case 90:
                area = new Rect(area.y, area.x, area.height, area.width);
                break;
            case 180:
                break;
            case 270:
                area = new Rect(area.y, area.x, area.height, area.width);
                break;
        }
        const innerResult = this.inner.apply(area, tiles);
        switch (this.angle) {
            case 0:
                return innerResult;
            case 90:
                return innerResult.map((g) => new Rect(g.y, g.x, g.height, g.width));
            case 180:
                return innerResult.map((g) => {
                    const rx = g.x - area.x;
                    const newX = area.x + area.width - (rx + g.width);
                    return new Rect(newX, g.y, g.width, g.height);
                });
            case 270:
                return innerResult.map((g) => {
                    const rx = g.x - area.x;
                    const newY = area.x + area.width - (rx + g.width);
                    return new Rect(g.y, newY, g.height, g.width);
                });
        }
    }
    rotate(amount) {
        let angle = this.angle + amount;
        if (angle < 0)
            angle = 270;
        else if (angle >= 360)
            angle = 0;
        this.angle = angle;
    }
}
class LayoutUtils {
    static splitWeighted([begin, length], weights, gap) {
        gap = gap !== undefined ? gap : 0;
        const n = weights.length;
        const actualLength = length - (n - 1) * gap;
        const weightSum = weights.reduce((sum, weight) => sum + weight, 0);
        let weightAcc = 0;
        return weights.map((weight, i) => {
            const partBegin = (actualLength * weightAcc) / weightSum + i * gap;
            const partLength = (actualLength * weight) / weightSum;
            weightAcc += weight;
            return [begin + Math.floor(partBegin), Math.floor(partLength)];
        });
    }
    static splitAreaWeighted(area, weights, gap, horizontal) {
        gap = gap !== undefined ? gap : 0;
        horizontal = horizontal !== undefined ? horizontal : false;
        const line = horizontal
            ? [area.x, area.width]
            : [area.y, area.height];
        const parts = LayoutUtils.splitWeighted(line, weights, gap);
        return parts.map(([begin, length]) => horizontal
            ? new Rect(begin, area.y, length, area.height)
            : new Rect(area.x, begin, area.width, length));
    }
    static splitAreaHalfWeighted(area, weight, gap, horizontal) {
        return LayoutUtils.splitAreaWeighted(area, [weight, 1 - weight], gap, horizontal);
    }
    static adjustWeights([begin, length], weights, gap, target, deltaFw, deltaBw) {
        const minLength = 1;
        const parts = this.splitWeighted([begin, length], weights, gap);
        const [targetBase, targetLength] = parts[target];
        if (target > 0 && deltaBw !== 0) {
            const neighbor = target - 1;
            const [neighborBase, neighborLength] = parts[neighbor];
            const delta = clip(deltaBw, minLength - targetLength, neighborLength - minLength);
            parts[target] = [targetBase - delta, targetLength + delta];
            parts[neighbor] = [neighborBase, neighborLength - delta];
        }
        if (target < parts.length - 1 && deltaFw !== 0) {
            const neighbor = target + 1;
            const [neighborBase, neighborLength] = parts[neighbor];
            const delta = clip(deltaFw, minLength - targetLength, neighborLength - minLength);
            parts[target] = [targetBase, targetLength + delta];
            parts[neighbor] = [neighborBase + delta, neighborLength - delta];
        }
        return LayoutUtils.calculateWeights(parts);
    }
    static adjustAreaWeights(area, weights, gap, target, delta, horizontal) {
        const line = horizontal
            ? [area.x, area.width]
            : [area.y, area.height];
        const [deltaFw, deltaBw] = horizontal
            ? [delta.east, delta.west]
            : [delta.south, delta.north];
        return LayoutUtils.adjustWeights(line, weights, gap, target, deltaFw, deltaBw);
    }
    static adjustAreaHalfWeights(area, weight, gap, target, delta, horizontal) {
        const weights = [weight, 1 - weight];
        const newWeights = LayoutUtils.adjustAreaWeights(area, weights, gap, target, delta, horizontal);
        return newWeights[0];
    }
    static calculateWeights(parts) {
        const totalLength = parts.reduce((acc, [base, length]) => acc + length, 0);
        return parts.map(([base, length]) => length / totalLength);
    }
    static calculateAreaWeights(area, geometries, gap, horizontal) {
        gap = gap !== undefined ? gap : 0;
        horizontal = horizontal !== undefined ? horizontal : false;
        const line = horizontal ? area.width : area.height;
        const parts = horizontal
            ? geometries.map((geometry) => [geometry.x, geometry.width])
            : geometries.map((geometry) => [geometry.y, geometry.height]);
        return LayoutUtils.calculateWeights(parts);
    }
}
class MonocleLayout {
    constructor() {
        this.description = "Monocle";
        this.classID = MonocleLayout.id;
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tile) => {
            tile.state = CONFIG.monocleMaximize
                ? WindowState.Maximized
                : WindowState.Tiled;
            tile.geometry = area;
        });
        if (ctx.backend === KWinDriver.backendName &&
            KWINCONFIG.monocleMinimizeRest) {
            const tiles = [...tileables];
            ctx.setTimeout(() => {
                const current = ctx.currentWindow;
                if (current && current.tiled) {
                    tiles.forEach((window) => {
                        if (window !== current)
                            window.window.window.minimized = true;
                    });
                }
            }, 50);
        }
    }
    clone() {
        return this;
    }
    handleShortcut(ctx, input, data) {
        switch (input) {
            case Shortcut.DWMLeft:
            case Shortcut.FocusNext:
            case Shortcut.FocusUp:
            case Shortcut.FocusLeft:
                ctx.cycleFocus(-1);
                return true;
            case Shortcut.DWMRight:
            case Shortcut.FocusPrev:
            case Shortcut.FocusDown:
            case Shortcut.FocusRight:
                ctx.cycleFocus(1);
                return true;
            default:
                return false;
        }
    }
    toString() {
        return "MonocleLayout()";
    }
}
MonocleLayout.id = "MonocleLayout";
class QuarterLayout {
    get capacity() {
        return 4;
    }
    constructor() {
        this.classID = QuarterLayout.id;
        this.description = "Quarter";
        this.lhsplit = 0.5;
        this.rhsplit = 0.5;
        this.vsplit = 0.5;
    }
    adjust(area, tiles, basis, delta) {
        if (tiles.length <= 1 || tiles.length > 4)
            return;
        const idx = tiles.indexOf(basis);
        if (idx < 0)
            return;
        if ((idx === 0 || idx === 3) && delta.east !== 0)
            this.vsplit =
                (Math.floor(area.width * this.vsplit) + delta.east) / area.width;
        else if ((idx === 1 || idx === 2) && delta.west !== 0)
            this.vsplit =
                (Math.floor(area.width * this.vsplit) - delta.west) / area.width;
        if (tiles.length === 4) {
            if (idx === 0 && delta.south !== 0)
                this.lhsplit =
                    (Math.floor(area.height * this.lhsplit) + delta.south) / area.height;
            if (idx === 3 && delta.north !== 0)
                this.lhsplit =
                    (Math.floor(area.height * this.lhsplit) - delta.north) / area.height;
        }
        if (tiles.length >= 3) {
            if (idx === 1 && delta.south !== 0)
                this.rhsplit =
                    (Math.floor(area.height * this.rhsplit) + delta.south) / area.height;
            if (idx === 2 && delta.north !== 0)
                this.rhsplit =
                    (Math.floor(area.height * this.rhsplit) - delta.north) / area.height;
        }
        this.vsplit = clip(this.vsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
        this.lhsplit = clip(this.lhsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
        this.rhsplit = clip(this.rhsplit, 1 - QuarterLayout.MAX_PROPORTION, QuarterLayout.MAX_PROPORTION);
    }
    clone() {
        const other = new QuarterLayout();
        other.lhsplit = this.lhsplit;
        other.rhsplit = this.rhsplit;
        other.vsplit = this.vsplit;
        return other;
    }
    apply(ctx, tileables, area) {
        for (let i = 0; i < 4 && i < tileables.length; i++)
            tileables[i].state = WindowState.Tiled;
        if (tileables.length > 4)
            tileables
                .slice(4)
                .forEach((tile) => (tile.state = WindowState.TiledAfloat));
        if (tileables.length === 1) {
            tileables[0].geometry = area;
            return;
        }
        const gap1 = Math.floor(CONFIG.tileLayoutGap / 2);
        const gap2 = CONFIG.tileLayoutGap - gap1;
        const leftWidth = Math.floor(area.width * this.vsplit);
        const rightWidth = area.width - leftWidth;
        const rightX = area.x + leftWidth;
        if (tileables.length === 2) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, area.height).gap(0, gap1, 0, 0);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, area.height).gap(gap2, 0, 0, 0);
            return;
        }
        const rightTopHeight = Math.floor(area.height * this.rhsplit);
        const rightBottomHeight = area.height - rightTopHeight;
        const rightBottomY = area.y + rightTopHeight;
        if (tileables.length === 3) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, area.height).gap(0, gap1, 0, 0);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, rightTopHeight).gap(gap2, 0, 0, gap1);
            tileables[2].geometry = new Rect(rightX, rightBottomY, rightWidth, rightBottomHeight).gap(gap2, 0, gap2, 0);
            return;
        }
        const leftTopHeight = Math.floor(area.height * this.lhsplit);
        const leftBottomHeight = area.height - leftTopHeight;
        const leftBottomY = area.y + leftTopHeight;
        if (tileables.length >= 4) {
            tileables[0].geometry = new Rect(area.x, area.y, leftWidth, leftTopHeight).gap(0, gap1, 0, gap1);
            tileables[1].geometry = new Rect(rightX, area.y, rightWidth, rightTopHeight).gap(gap2, 0, 0, gap1);
            tileables[2].geometry = new Rect(rightX, rightBottomY, rightWidth, rightBottomHeight).gap(gap2, 0, gap2, 0);
            tileables[3].geometry = new Rect(area.x, leftBottomY, leftWidth, leftBottomHeight).gap(0, gap2, gap2, 0);
        }
    }
    toString() {
        return "QuarterLayout()";
    }
}
QuarterLayout.MAX_PROPORTION = 0.8;
QuarterLayout.id = "QuarterLayout";
class SpiralLayout {
    constructor() {
        this.description = "Spiral";
        this.classID = SpiralLayout.id;
        this.depth = 1;
        this.parts = new HalfSplitLayoutPart(new FillLayoutPart(), new FillLayoutPart());
        this.parts.angle = 0;
        this.parts.gap = CONFIG.tileLayoutGap;
    }
    adjust(area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        this.bore(tileables.length);
        this.parts.apply(area, tileables).forEach((geometry, i) => {
            tileables[i].geometry = geometry;
        });
    }
    toString() {
        return "Spiral()";
    }
    bore(depth) {
        if (this.depth >= depth)
            return;
        let hpart = this.parts;
        let i;
        for (i = 0; i < this.depth - 1; i++) {
            hpart = hpart.secondary;
        }
        const lastFillPart = hpart.secondary;
        let npart;
        while (i < depth - 1) {
            npart = new HalfSplitLayoutPart(new FillLayoutPart(), lastFillPart);
            npart.gap = CONFIG.tileLayoutGap;
            npart.angle = (((i + 1) % 4) * 90);
            hpart.secondary = npart;
            hpart = npart;
            i++;
        }
        this.depth = depth;
    }
}
SpiralLayout.id = "SpiralLayout";
class SpreadLayout {
    constructor() {
        this.classID = SpreadLayout.id;
        this.description = "Spread";
        this.space = 0.07;
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        const tiles = tileables;
        let numTiles = tiles.length;
        const spaceWidth = Math.floor(area.width * this.space);
        let cardWidth = area.width - spaceWidth * (numTiles - 1);
        const miniumCardWidth = area.width * 0.4;
        while (cardWidth < miniumCardWidth) {
            cardWidth += spaceWidth;
            numTiles -= 1;
        }
        for (let i = 0; i < tiles.length; i++)
            tiles[i].geometry = new Rect(area.x + (i < numTiles ? spaceWidth * (numTiles - i - 1) : 0), area.y, cardWidth, area.height);
    }
    clone() {
        const other = new SpreadLayout();
        other.space = this.space;
        return other;
    }
    handleShortcut(ctx, input) {
        switch (input) {
            case Shortcut.Decrease:
                this.space = Math.max(0.04, this.space - 0.01);
                break;
            case Shortcut.Increase:
                this.space = Math.min(0.1, this.space + 0.01);
                break;
            default:
                return false;
        }
        return true;
    }
    toString() {
        return "SpreadLayout(" + this.space + ")";
    }
}
SpreadLayout.id = "SpreadLayout";
class StackedLayout {
    get description() {
        return "Stacked";
    }
    constructor() {
        this.classID = StackedLayout.id;
        this.parts = new RotateLayoutPart(new HalfSplitLayoutPart(new StackLayoutPart(), new StackLayoutPart()));
        const masterPart = this.parts.inner;
        masterPart.gap =
            masterPart.secondary.gap =
                CONFIG.tileLayoutGap;
    }
    adjust(area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        if (tileables.length > 1) {
            this.parts.inner.angle = 90;
        }
        this.parts.apply(area, tileables).forEach((geometry, i) => {
            tileables[i].geometry = geometry;
        });
    }
    clone() {
        const other = new StackedLayout();
        return other;
    }
    handleShortcut(ctx, input) {
        switch (input) {
            case Shortcut.Rotate:
                this.parts.rotate(90);
                break;
            default:
                return false;
        }
        return true;
    }
    toString() {
        return ("StackedLayout()");
    }
}
StackedLayout.id = "StackedLayout";
class StairLayout {
    constructor() {
        this.classID = StairLayout.id;
        this.description = "Stair";
        this.space = 24;
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        const tiles = tileables;
        const len = tiles.length;
        const space = this.space;
        const alignRight = Number(!KWINCONFIG.stairReverse);
        for (let i = 0; i < len; i++) {
            const dx = space * (len - i - 1);
            const dy = space * i;
            tiles[i].geometry = new Rect(area.x + alignRight * dx, area.y + dy, area.width - dx, area.height - dy);
        }
    }
    clone() {
        const other = new StairLayout();
        other.space = this.space;
        return other;
    }
    handleShortcut(ctx, input) {
        switch (input) {
            case Shortcut.Decrease:
                this.space = Math.max(16, this.space - 8);
                break;
            case Shortcut.Increase:
                this.space = Math.min(160, this.space + 8);
                break;
            default:
                return false;
        }
        return true;
    }
    toString() {
        return "StairLayout(" + this.space + ")";
    }
}
StairLayout.id = "StairLayout";
class ThreeColumnLayout {
    get description() {
        return "Three-Column [" + this.masterSize + "]";
    }
    constructor() {
        this.classID = ThreeColumnLayout.id;
        this.masterRatio = 0.6;
        this.masterSize = 1;
    }
    adjust(area, tiles, basis, delta) {
        const basisIndex = tiles.indexOf(basis);
        if (basisIndex < 0)
            return;
        if (tiles.length === 0)
            return;
        else if (tiles.length <= this.masterSize) {
            LayoutUtils.adjustAreaWeights(area, tiles.map((tile) => tile.weight), CONFIG.tileLayoutGap, tiles.indexOf(basis), delta).forEach((newWeight, i) => (tiles[i].weight = newWeight * tiles.length));
        }
        else if (tiles.length === this.masterSize + 1) {
            this.masterRatio = LayoutUtils.adjustAreaHalfWeights(area, this.masterRatio, CONFIG.tileLayoutGap, basisIndex < this.masterSize ? 0 : 1, delta, true);
            if (basisIndex < this.masterSize) {
                const masterTiles = tiles.slice(0, -1);
                LayoutUtils.adjustAreaWeights(area, masterTiles.map((tile) => tile.weight), CONFIG.tileLayoutGap, basisIndex, delta).forEach((newWeight, i) => (masterTiles[i].weight = newWeight * masterTiles.length));
            }
        }
        else if (tiles.length > this.masterSize + 1) {
            let basisGroup;
            if (basisIndex < this.masterSize)
                basisGroup = 1;
            else if (basisIndex < Math.floor((this.masterSize + tiles.length) / 2))
                basisGroup = 2;
            else
                basisGroup = 0;
            const stackRatio = 1 - this.masterRatio;
            const newRatios = LayoutUtils.adjustAreaWeights(area, [stackRatio, this.masterRatio, stackRatio], CONFIG.tileLayoutGap, basisGroup, delta, true);
            const newMasterRatio = newRatios[1];
            const newStackRatio = basisGroup === 0 ? newRatios[0] : newRatios[2];
            this.masterRatio = newMasterRatio / (newMasterRatio + newStackRatio);
            const rstackNumTile = Math.floor((tiles.length - this.masterSize) / 2);
            const [masterTiles, rstackTiles, lstackTiles] = partitionArrayBySizes(tiles, [
                this.masterSize,
                rstackNumTile,
            ]);
            const groupTiles = [lstackTiles, masterTiles, rstackTiles][basisGroup];
            LayoutUtils.adjustAreaWeights(area, groupTiles.map((tile) => tile.weight), CONFIG.tileLayoutGap, groupTiles.indexOf(basis), delta).forEach((newWeight, i) => (groupTiles[i].weight = newWeight * groupTiles.length));
        }
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        const tiles = tileables;
        if (tiles.length <= this.masterSize) {
            LayoutUtils.splitAreaWeighted(area, tiles.map((tile) => tile.weight), CONFIG.tileLayoutGap).forEach((tileArea, i) => (tiles[i].geometry = tileArea));
        }
        else if (tiles.length === this.masterSize + 1) {
            const [masterArea, stackArea] = LayoutUtils.splitAreaHalfWeighted(area, this.masterRatio, CONFIG.tileLayoutGap, true);
            const masterTiles = tiles.slice(0, this.masterSize);
            LayoutUtils.splitAreaWeighted(masterArea, masterTiles.map((tile) => tile.weight), CONFIG.tileLayoutGap).forEach((tileArea, i) => (masterTiles[i].geometry = tileArea));
            tiles[tiles.length - 1].geometry = stackArea;
        }
        else if (tiles.length > this.masterSize + 1) {
            const stackRatio = 1 - this.masterRatio;
            const groupAreas = LayoutUtils.splitAreaWeighted(area, [stackRatio, this.masterRatio, stackRatio], CONFIG.tileLayoutGap, true);
            const rstackSize = Math.floor((tiles.length - this.masterSize) / 2);
            const [masterTiles, rstackTiles, lstackTiles] = partitionArrayBySizes(tiles, [
                this.masterSize,
                rstackSize,
            ]);
            [lstackTiles, masterTiles, rstackTiles].forEach((groupTiles, group) => {
                LayoutUtils.splitAreaWeighted(groupAreas[group], groupTiles.map((tile) => tile.weight), CONFIG.tileLayoutGap).forEach((tileArea, i) => (groupTiles[i].geometry = tileArea));
            });
        }
    }
    clone() {
        const other = new ThreeColumnLayout();
        other.masterRatio = this.masterRatio;
        other.masterSize = this.masterSize;
        return other;
    }
    handleShortcut(ctx, input, data) {
        switch (input) {
            case Shortcut.Increase:
                this.resizeMaster(ctx, +1);
                return true;
            case Shortcut.Decrease:
                this.resizeMaster(ctx, -1);
                return true;
            case Shortcut.DWMLeft:
                this.masterRatio = clip(slide(this.masterRatio, -0.05), ThreeColumnLayout.MIN_MASTER_RATIO, ThreeColumnLayout.MAX_MASTER_RATIO);
                return true;
            case Shortcut.DWMRight:
                this.masterRatio = clip(slide(this.masterRatio, +0.05), ThreeColumnLayout.MIN_MASTER_RATIO, ThreeColumnLayout.MAX_MASTER_RATIO);
                return true;
            default:
                return false;
        }
    }
    toString() {
        return "ThreeColumnLayout(nmaster=" + this.masterSize + ")";
    }
    resizeMaster(ctx, step) {
        this.masterSize = clip(this.masterSize + step, 1, 10);
        ctx.showNotification(this.description);
    }
}
ThreeColumnLayout.MIN_MASTER_RATIO = 0.2;
ThreeColumnLayout.MAX_MASTER_RATIO = 0.75;
ThreeColumnLayout.id = "ThreeColumnLayout";
class TileLayout {
    get description() {
        return "Tile [" + this.numMaster + "]";
    }
    get numMaster() {
        return this.parts.inner.primarySize;
    }
    set numMaster(value) {
        this.parts.inner.primarySize = value;
    }
    get masterRatio() {
        return this.parts.inner.ratio;
    }
    set masterRatio(value) {
        this.parts.inner.ratio = value;
    }
    constructor() {
        this.classID = TileLayout.id;
        this.parts = new RotateLayoutPart(new HalfSplitLayoutPart(new RotateLayoutPart(new StackLayoutPart()), new StackLayoutPart()));
        switch (CONFIG.tileLayoutInitialAngle) {
            case "1": {
                this.parts.angle = 90;
                break;
            }
            case "2": {
                this.parts.angle = 180;
                break;
            }
            case "3": {
                this.parts.angle = 270;
                break;
            }
        }
        const masterPart = this.parts.inner;
        masterPart.gap =
            masterPart.primary.inner.gap =
                masterPart.secondary.gap =
                    CONFIG.tileLayoutGap;
    }
    adjust(area, tiles, basis, delta) {
        this.parts.adjust(area, tiles, basis, delta);
    }
    apply(ctx, tileables, area) {
        tileables.forEach((tileable) => (tileable.state = WindowState.Tiled));
        this.parts.apply(area, tileables).forEach((geometry, i) => {
            tileables[i].geometry = geometry;
        });
    }
    clone() {
        const other = new TileLayout();
        other.masterRatio = this.masterRatio;
        other.numMaster = this.numMaster;
        return other;
    }
    handleShortcut(ctx, input) {
        switch (input) {
            case Shortcut.DWMLeft:
                this.masterRatio = clip(slide(this.masterRatio, -0.05), TileLayout.MIN_MASTER_RATIO, TileLayout.MAX_MASTER_RATIO);
                break;
            case Shortcut.DWMRight:
                this.masterRatio = clip(slide(this.masterRatio, +0.05), TileLayout.MIN_MASTER_RATIO, TileLayout.MAX_MASTER_RATIO);
                break;
            case Shortcut.Increase:
                if (this.numMaster < 10)
                    this.numMaster += 1;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Decrease:
                if (this.numMaster > 0)
                    this.numMaster -= 1;
                ctx.showNotification(this.description);
                break;
            case Shortcut.Rotate:
                this.parts.rotate(90);
                break;
            case Shortcut.RotatePart:
                this.parts.inner.primary.rotate(90);
                break;
            default:
                return false;
        }
        return true;
    }
    toString() {
        return ("TileLayout(nmaster=" +
            this.numMaster +
            ", ratio=" +
            this.masterRatio +
            ")");
    }
}
TileLayout.MIN_MASTER_RATIO = 0.2;
TileLayout.MAX_MASTER_RATIO = 0.8;
TileLayout.id = "TileLayout";
const DEBUG = {
    enabled: false,
    started: new Date().getTime(),
};
function debug(f) {
    if (DEBUG.enabled) {
        const timestamp = (new Date().getTime() - DEBUG.started) / 1000;
        console.log("[" + timestamp + "]", f());
    }
}
function debugObj(f) {
    if (DEBUG.enabled) {
        const timestamp = (new Date().getTime() - DEBUG.started) / 1000;
        const [name, obj] = f();
        const buf = [];
        for (const i in obj)
            buf.push(i + "=" + obj[i]);
        console.log("[" + timestamp + "]", name + ": " + buf.join(" "));
    }
}
function clip(value, min, max) {
    if (value < min)
        return min;
    if (value > max)
        return max;
    return value;
}
function slide(value, step) {
    if (step === 0)
        return value;
    return Math.floor(value / step + 1.000001) * step;
}
function matchWords(str, words) {
    for (let i = 0; i < words.length; i++) {
        if (str.indexOf(words[i]) >= 0)
            return i;
    }
    return -1;
}
function wrapIndex(index, length) {
    if (index < 0)
        return index + length;
    if (index >= length)
        return index - length;
    return index;
}
function partitionArray(array, predicate) {
    return array.reduce((parts, item, index) => {
        parts[predicate(item, index) ? 0 : 1].push(item);
        return parts;
    }, [[], []]);
}
function partitionArrayBySizes(array, sizes) {
    let base = 0;
    const chunks = sizes.map((size) => {
        const chunk = array.slice(base, base + size);
        base += size;
        return chunk;
    });
    chunks.push(array.slice(base));
    return chunks;
}
function overlap(min1, max1, min2, max2) {
    const min = Math.min;
    const max = Math.max;
    const dx = max(0, min(max1, max2) - max(min1, min2));
    return dx > 0;
}
function toQRect(rect) {
    return Qt.rect(rect.x, rect.y, rect.width, rect.height);
}
function toRect(qrect) {
    return new Rect(qrect.x, qrect.y, qrect.width, qrect.height);
}
class Rect {
    constructor(x, y, width, height) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
    }
    get maxX() {
        return this.x + this.width;
    }
    get maxY() {
        return this.y + this.height;
    }
    get center() {
        return [
            this.x + Math.floor(this.width / 2),
            this.y + Math.floor(this.height / 2),
        ];
    }
    get activationPoint() {
        return [this.x + Math.floor(this.width / 2), this.y + 10];
    }
    clone() {
        return new Rect(this.x, this.y, this.width, this.height);
    }
    equals(other) {
        return (this.x === other.x &&
            this.y === other.y &&
            this.width === other.width &&
            this.height === other.height);
    }
    gap(left, right, top, bottom) {
        return new Rect(this.x + left, this.y + top, this.width - (left + right), this.height - (top + bottom));
    }
    gap_mut(left, right, top, bottom) {
        this.x += left;
        this.y += top;
        this.width -= left + right;
        this.height -= top + bottom;
        return this;
    }
    includes(other) {
        return (this.x <= other.x &&
            this.y <= other.y &&
            other.maxX < this.maxX &&
            other.maxY < this.maxY);
    }
    includesPoint([x, y], part = 4) {
        if (part === 0)
            return (this.x <= x &&
                x <= this.maxX &&
                this.y <= y &&
                y <= this.y + this.height / 2);
        else if (part === 1)
            return (this.x <= x &&
                x <= this.maxX &&
                y > this.y + this.height / 2 &&
                y <= this.maxY);
        else if (part === 2) {
            return (this.y <= y &&
                y <= this.maxY &&
                this.x <= x &&
                x <= this.x + this.height / 2);
        }
        else if (part === 3) {
            return (this.y <= y &&
                y <= this.maxY &&
                x > this.x + this.width / 2 &&
                x <= this.maxX);
        }
        else {
            return this.x <= x && x <= this.maxX && this.y <= y && y <= this.maxY;
        }
    }
    isTopZone([x, y], activeZone = 10) {
        return (this.y <= y &&
            y <= this.y + (this.height * activeZone) / 100 &&
            this.x <= x &&
            x <= this.maxX);
    }
    isBottomZone([x, y], activeZone = 10) {
        return (y >= this.maxY - (this.height * activeZone) / 100 &&
            y <= this.maxY &&
            this.x <= x &&
            x <= this.maxX);
    }
    isLeftZone([x, y], activeZone = 10) {
        return (this.x <= x &&
            x <= this.x + (this.width * activeZone) / 100 &&
            this.y <= y &&
            y <= this.maxY);
    }
    isRightZone([x, y], activeZone = 10) {
        return (x >= this.maxX - (this.width * activeZone) / 100 &&
            x <= this.maxX &&
            this.y <= y &&
            y <= this.maxY);
    }
    subtract(other) {
        return new Rect(this.x - other.x, this.y - other.y, this.width - other.width, this.height - other.height);
    }
    toString() {
        return "Rect(" + [this.x, this.y, this.width, this.height].join(", ") + ")";
    }
}
class RectDelta {
    static fromRects(basis, target) {
        const diff = target.subtract(basis);
        return new RectDelta(diff.width + diff.x, -diff.x, diff.height + diff.y, -diff.y);
    }
    constructor(east, west, south, north) {
        this.east = east;
        this.west = west;
        this.south = south;
        this.north = north;
    }
    toString() {
        return ("WindowResizeDelta(" +
            [
                "east=" + this.east,
                "west=" + this.west,
                "north=" + this.north,
                "south=" + this.south,
            ].join(" ") +
            ")");
    }
}
class windRose {
    constructor(direction) {
        switch (direction) {
            case "0":
                this.direction = 0;
                break;
            case "1":
                this.direction = 1;
                break;
            case "2":
                this.direction = 2;
                break;
            case "3":
                this.direction = 3;
                break;
            default:
                this.direction = 0;
        }
    }
    get north() {
        return this.direction === 0;
    }
    get east() {
        return this.direction === 1;
    }
    get south() {
        return this.direction === 2;
    }
    get west() {
        return this.direction === 3;
    }
    cwRotation() {
        this.direction = (this.direction + 1) % 4;
    }
    ccwRotation() {
        this.direction = this.direction - 1 >= 0 ? this.direction - 1 : 3;
    }
    toString() {
        switch (this.direction) {
            case 0: {
                return "North";
            }
            case 1: {
                return "East";
            }
            case 2: {
                return "South";
            }
            case 3: {
                return "West";
            }
            default: {
                return "Unknown";
            }
        }
    }
}
class WrapperMap {
    constructor(hasher, wrapper) {
        this.hasher = hasher;
        this.wrapper = wrapper;
        this.items = {};
    }
    add(item) {
        const key = this.hasher(item);
        if (this.items[key] !== undefined)
            throw "WrapperMap: the key [" + key + "] already exists!";
        const wrapped = this.wrapper(item);
        this.items[key] = wrapped;
        return wrapped;
    }
    get(item) {
        const key = this.hasher(item);
        return this.items[key] || null;
    }
    getByKey(key) {
        return this.items[key] || null;
    }
    remove(item) {
        const key = this.hasher(item);
        return delete this.items[key];
    }
    length() {
        return Object.keys(this.items).length;
    }
}
