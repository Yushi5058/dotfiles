config.load_autoconfig(False)

c.qt.args = [
    "disable-gpu-memory-buffer-video-frames",
    "disable-reading-from-canvas",
    "num-raster-threads=2",
    "enable-parallel-downloading",
    "disable-gpu",
]

c.qt.chromium.process_model = "process-per-site"

c.content.blocking.method = "adblock"
c.content.autoplay = False

c.editor.command = ["foot", "nvim", "{file}", "-c", "normal {line}G{column0}l"]

config.bind("pw", "spawn --userscript qute-bw")
config.bind("m", "spawn mpv {url}")
config.bind("M", "hint links spawn mpv {hint-url}")

config.bind("xp", "set content.proxy http://127.0.0.1:8080/")
config.bind("xP", "set content.proxy system")

c.content.canvas_reading = False
c.colors.webpage.darkmode.enabled = True