# -*- coding: utf-8 -*-
from typing import List  # noqa: F401
from libqtile.utils import guess_terminal
from libqtile.config import Key, Match, Screen, Group, Drag, Click
from libqtile.command import lazy
from libqtile import layout, hook, bar, widget
import os
import subprocess


mod = "mod4"  # Sets mod key to SUPER/WINDOWS
# mod = "mod1"
# myTerm = guess_terminal()                            # My terminal of choice
myTerm = "kitty"

keys = [
        # Layout hotkeys
        Key([mod], "h", lazy.layout.shrink_main()),
        Key([mod], "l", lazy.layout.grow_main()),
        Key([mod], "j", lazy.layout.down()),
        Key([mod], "k", lazy.layout.up()),
        Key([mod, "shift"], "j", lazy.layout.shuffle_down()),
        Key([mod, "shift"], "k", lazy.layout.shuffle_up()),
        Key([mod], "n", lazy.layout.normalize()),
        Key([mod], "o", lazy.layout.maximize()),
        # Key([mod], 'r', lazy.spawncmd()),
        Key(
            [mod, "shift"],
            "space",
            lazy.layout.rotate(),
            lazy.layout.flip(),
            desc="Switch which side main pane occupies (XmonadTall)",
            ),
        ### Switch focus to specific monitor (out of three)
        # Key([mod], "w",
        #    lazy.to_screen(0),
        #    desc='Keyboard focus to monitor 1'
        #    ),
        # Key([mod], "e",
        #   lazy.to_screen(1),
        #    desc='Keyboard focus to monitor 2'
        #    ),
        #Key([mod], "r",
        #   lazy.to_screen(2),
        #   desc='Keyboard focus to monitor 3'
        #   ),
        ### Switch focus of monitors
        Key([mod], "period",
            lazy.next_screen(),
            desc='Move focus to next monitor'
            ),
        Key([mod], "comma",
            lazy.prev_screen(),
            desc='Move focus to prev monitor'
            ),
        # Window hotkeys
        Key([mod], "space", lazy.window.toggle_fullscreen()),
        Key([mod], "c", lazy.window.kill()),
        # Spec hotkeys
        Key([mod, "control"], "r", lazy.restart()),
        Key([mod, "control"], "q", lazy.shutdown()),
        # Apps hotkeys
        Key([mod], "Return", lazy.spawn(myTerm), desc="Launch terminal"),
        Key([mod], "f", lazy.spawn("firefox")),
        Key([mod, "shift"], "f", lazy.spawn("firefox-dev -P default")),
        Key([mod], "v", lazy.spawn("code . -n")),
Key([mod], "e", lazy.spawn("pcmanfm")),
    Key([mod], "m", lazy.spawn("flatpak run com.spotify.Client")),
    Key([mod], "p", lazy.spawn("flatpak run com.bitwarden.desktop ")),
    # ROFI DMENU
    Key([mod], "s", lazy.spawn(".config/rofi/web-search.sh")),
    Key([mod], "d", lazy.spawn(".config/rofi/github-repos.sh")),
    Key(
            [mod], "a", lazy.spawn("rofi  -show calc -modi calc:.config/rofi/rofi-calc.sh")
            ),
    Key([mod], "w", lazy.spawn("rofi -show window")),
    Key([mod], "a", lazy.spawn("rofi -show ssh")),
    Key([mod], "r", lazy.spawn("rofi -show drun")),
    Key([mod], "x", lazy.spawn("rofi -show emoji -modi emoji")),
    # System hotkeys
    Key([mod, "shift", "control"], "F11", lazy.spawn("sudo hibernate-reboot")),
    Key([mod, "shift", "control"], "F12", lazy.spawn("systemctl hibernate")),
    Key([], "Print", lazy.spawn("scrot -e 'mv $f /home/dominik/bilder/screenshots/'")),
    # Media hotkeys
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pulseaudio-ctl up 5")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pulseaudio-ctl down 5")),
    Key([], "XF86AudioMute", lazy.spawn("pulseaudio-ctl set 1")),
    Key([mod, "control"], "space", lazy.widget["keyboardlayout"].next_keyboard(), desc="Next keyboard layout."),
]


# GROUPS
#
group_names = [
        ("DEV", {"layout": "monadtall"}),
        ("TERM", {"layout": "tile"}),
        ("WWW", {"layout": "monadtall"}),
        ("DB", {"layout": "tile"}),
        ("STUFF", {"layout": "floating"}),
        ("FILE", {"layout": "treetab"}),
        ("MUSK", {"layout": "tile"}),
        ]

groups = [Group(name, **kwargs) for name, kwargs in group_names]

for i, (name, kwargs) in enumerate(group_names, 1):
    # Switch to another group
    keys.append(Key([mod], str(i), lazy.group[name].toscreen()))
    # Send current window to another group
    keys.append(Key([mod, "shift"], str(i), lazy.window.togroup(name)))


panel_color = "#2b2b2b"
primary_color = "#cc7832"
white_color = "#9876aa"
border_act_color = "#cc7832"
border_color = "#2b2b2b"
secondary_dark_color = "#769aa5"
secondary_color = "#9876aa"
tab_color = "#808080"
gray_light_color = "#646E82"
gray_dark_color = "#a5c25c"

gray="#2b2b2b"
gray_light="#5f5f5f"
blue="#769aa5"
orange="#cc7832"
green="#a5c25c"
lila="#9876aa"
white="#FFFFFF"

layout_theme = {
        "border_width": 2,
        "margin": 5,
        "border_focus": green,
        "border_normal": gray,
        }

layouts = [
        # layout.MonadWide(**layout_theme),
        # layout.Bsp(**layout_theme),
        # layout.Stack(stacks=2, **layout_theme),
        # layout.Columns(**layout_theme),
        # layout.RatioTile(**layout_theme),
        layout.VerticalTile(**layout_theme),
        # layout.Matrix(**layout_theme),
        # layout.Zoomy(**layout_theme),
        layout.MonadTall(shift_windows=True, **layout_theme),
        layout.Max(**layout_theme),
        layout.Tile(shift_windows=True, **layout_theme),
        layout.Stack(num_stacks=2),
        layout.TreeTab(
            font="Fira Code",
            fontsize=10,
            sections=["FIRST", "SECOND"],
            section_fontsize=11,
            bg_color=gray,
            active_bg=lila,
            active_fg=white,
            inactive_bg=gray,
            inactive_fg=blue,
            padding_y=5,
            section_top=10,
            panel_width=250,
            ),
        layout.Floating(**layout_theme),
        ]


##### DEFAULT WIDGET SETTINGS #####
widget_defaults = dict(font="Fira Code", fontsize=12, padding=2, background=panel_color)


def init_widgets_list():
    widgets_list = [
            widget.Sep(
                linewidth=0, padding=6, foreground=white_color, background=panel_color
                ),
            widget.GroupBox(
                font="Fira Code Bold",
                fontsize=10,
                margin_y=3,
                margin_x=0,
                padding_y=10,
                padding_x=5,
                borderwidth=3,
                active=orange,
                inactive=gray_light,
                rounded=False,
                highlight_color=orange,
                urgent_text=green,
                urgent_alert_method="border",
                disable_drag=True,
                highlight_method="block",
                this_current_screen_border=green,
                this_screen_border=gray,
                other_current_screen_border=blue,
                other_screen_border=gray,
                foreground=white,
                background=gray,
                ),
            widget.Prompt(
                prompt="run: ",
                ignore_dups_history=True,
                font="Fira Code",
                padding=10,
                foreground=orange,
                background=green,
                ),
            widget.Notify(),
            widget.Sep(
                linewidth=0, 
                padding=40, 
                foreground=white, 
                background=gray
                ),
            widget.WindowName(
                foreground=green, 
                background=gray, 
                padding=0),
            widget.Sep(
                linewidth=0,
                padding=20,
                foreground=lila,
                background=lila,
                ),
        widget.Sep(
                linewidth=0, 
                padding=20, 
                foreground=white, 
                background=lila
                ),
        widget.Clock(
                foreground=white,
                background=lila,
                format="%A, %B %d  [ %H:%M ]",
                ),
        widget.Memory(
                foreground=white, 
                background=lila
                ),
        widget.Net(
                interface="enp27s0",
                format="{down} ↓↑ {up}",
                foreground=white,
                background=lila,
                padding=5,
                ),
        widget.TextBox(
                text=" Vol:", 
                foreground=white, 
                background=lila, 
                padding=0
                ),
        widget.Volume(
                foreground=white, 
                background=lila, 
                padding=5
                ),
        widget.Sep(
                linewidth=0,
                padding=20,
                foreground=lila,
                background=lila,
                ),
        widget.Sep(
                linewidth=0, 
                padding=20, 
                foreground=green, 
                background=green
                ),
        widget.CurrentLayoutIcon(
                custom_icon_paths=[os.path.expanduser("~/.config/qtile/icons")],
                foreground=white,
                background=green,
                padding=0,
                scale=0.7,
                ),
        widget.Sep(
                linewidth=0, 
                padding=20, 
                foreground=green, 
                background=green
                ),
        widget.Sep(
                linewidth=0, 
                padding=20, 
                foreground=blue, 
                background=blue
                ),
        widget.KeyboardLayout(
                padding=20,
                foreground=white,
                background=blue,
                configured_keyboards=['us','de']
                ),
        widget.Systray(
                foreground=white, 
                background=blue, 
                padding=5
                ),
        widget.Sep(
                linewidth=0,
                padding=30,
                foreground=blue,
                background=blue,
                ),
    ]
    return widgets_list


def init_widgets_screen1():
    widgets_screen1 = init_widgets_list()
    return widgets_screen1  # Slicing removes unwanted widgets on Monitors 1,3


def init_widgets_screen2():
    widgets_screen2 = init_widgets_list()
    return widgets_screen2

def init_widgets_screen3():
    widgets_screen3 = init_widgets_list()
    return widgets_screen3

def init_screens():
    return [
            Screen(top=bar.Bar(widgets=init_widgets_screen1(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen2(), opacity=1.0, size=20)),
            Screen(top=bar.Bar(widgets=init_widgets_screen3(), opacity=1.0, size=20)),
            ]


if __name__ in ["config", "__main__"]:
    screens = init_screens()
    widgets_list = init_widgets_list()
    widgets_screen1 = init_widgets_screen1()
    widgets_screen2 = init_widgets_screen2()
    widgets_screen3 = init_widgets_screen3()


# Drag floating layouts.
mouse = [
        Drag(
            [mod],
            "Button1",
            lazy.window.set_position_floating(),
            start=lazy.window.get_position(),
            ),
        Drag(
            [mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()
            ),
        Click([mod], "Button2", lazy.window.bring_to_front()),
        ]

auto_fullscreen = True
focus_on_window_activation = "smart"
dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = True
cursor_warp = False
auto_fullscreen = True
extentions = []
wmname = "LG3D"

#

floating_layout = layout.Floating(float_rules=[
    # Run the utility of `xprop` to see the wm class and name of an X client.
    # default_float_rules include: utility, notification, toolbar, splash, dialog,
    # file_progress, confirm, download and error.
    *layout.Floating.default_float_rules,
    Match(title='Confirmation'),  # tastyworks exit box
    Match(title='Qalculate!'),  # qalculate-gtk
    Match(wm_class='kdenlive'),  # kdenlive
    Match(wm_class='pinentry-gtk-2'),  # GPG key password entry
    ])


@lazy.function
def float_to_front(qtile):
    logging.info("bring floating windows to front")
    for group in qtile.groups:
        for window in group.windows:
            if window.floating:
                window.cmd_bring_to_front()

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser("~/.config/qtile/autostart.sh")
    subprocess.call([home])

