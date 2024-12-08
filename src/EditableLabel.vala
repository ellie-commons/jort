/*
* Copyright (c) 2017 Lains
*
* This program is free software; you can redistribute it and/or
* modify it under the terms of the GNU General Public
* License as published by the Free Software Foundation; either
* version 2 of the License, or (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public
* License along with this program; if not, write to the
* Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
* Boston, MA 02110-1301 USA
*
* Co-authored by: Corentin Noël <corentin@elementary.io>
*
*/

public class Jort.EditableLabel : Gtk.EventBox {
    public signal void changed (string new_title);
    public Gtk.Label title;
    private Gtk.Entry entry;
    private Gtk.Stack stack;
    private Gtk.Grid grid;

    public string text {
        get {
            return title.label;
        }

        set {
            title.label = value;
        }
    }

    private bool editing {
        set {
            if (value) {
                entry.text = title.label;
                stack.set_visible_child (entry);
                entry.grab_focus ();
            } else {
                if (entry.text.strip () != "" && title.label != entry.text) {
                    title.label = entry.text;
                    changed (entry.text);
                }

                stack.set_visible_child (grid);
            }
        }
    }

    public EditableLabel (string? title_name) {
        valign = Gtk.Align.CENTER;
        events |= Gdk.EventMask.ENTER_NOTIFY_MASK;
        events |= Gdk.EventMask.LEAVE_NOTIFY_MASK;
        events |= Gdk.EventMask.BUTTON_PRESS_MASK;

        this.get_style_context().add_class("notejot-label");

        string style = null;
        var css_provider = new Gtk.CssProvider();
        style = """
        .notejot-label {
            font-weight: 700;
            font-size: 0.88em;
        }
        .notejot-label:backdrop {
            color: mix (@textColorPrimary, @colorPrimary, 0.3);
        }""";

        try {
            css_provider.load_from_data(style, -1);
        } catch (GLib.Error e) {
            warning ("Failed to parse css style : %s", e.message);
        }

        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            css_provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        );

        title = new Gtk.Label (title_name);
        title.ellipsize = Pango.EllipsizeMode.END;
        title.hexpand = true;

        var edit_button = new Gtk.Button ();
        edit_button.image = new Gtk.Image.from_icon_name ("edit-symbolic", Gtk.IconSize.MENU);
        edit_button.get_style_context ().add_class (Gtk.STYLE_CLASS_FLAT);
        var button_revealer = new Gtk.Revealer ();
        button_revealer.valign = Gtk.Align.CENTER;
        button_revealer.transition_type = Gtk.RevealerTransitionType.CROSSFADE;
        button_revealer.add (edit_button);

        var dummy_spacer = new Gtk.Grid ();

        var size_group = new Gtk.SizeGroup (Gtk.SizeGroupMode.HORIZONTAL);
        size_group.add_widget (dummy_spacer);
        size_group.add_widget (edit_button);

        grid = new Gtk.Grid ();
        grid.valign = Gtk.Align.CENTER;
        grid.column_spacing = 6;
        grid.hexpand = false;
        grid.add (dummy_spacer);
        grid.add (title);
        grid.add (button_revealer);

        entry = new Gtk.Entry ();
        entry.xalign = 0.5f;

        var entry_style_context = entry.get_style_context ();
        entry_style_context.add_class (Gtk.STYLE_CLASS_FLAT);
        entry_style_context.add_class (Gtk.STYLE_CLASS_TITLE);

        stack = new Gtk.Stack ();
        stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
        stack.add (grid);
        stack.add (entry);
        add (stack);

        enter_notify_event.connect ((event) => {
            if (event.detail != Gdk.NotifyType.INFERIOR) {
                button_revealer.set_reveal_child (true);
                event.window.set_cursor (new Gdk.Cursor.from_name (Gdk.Display.get_default(), "text"));
            }

            return false;
        });

        leave_notify_event.connect ((event) => {
            if (event.detail != Gdk.NotifyType.INFERIOR) {
                button_revealer.set_reveal_child (false);
            }
            event.window.set_cursor (new Gdk.Cursor.from_name (Gdk.Display.get_default(), "default"));

            return false;
        });

        button_release_event.connect ((event) => {
            editing = true;
            return false;
        });

        edit_button.clicked.connect (() => {
            editing = true;
        });

        entry.activate.connect (() => {
            editing = false;
        });

        entry.focus_out_event.connect ((event) => {
            editing = false;
            return false;
        });

        entry.icon_release.connect ((p0, p1) => {
            if (p0 == Gtk.EntryIconPosition.SECONDARY) {
                editing = false;
            }
        });
    }
}
