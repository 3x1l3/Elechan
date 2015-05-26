using Gtk;
using Granite.Widgets;
using GLib;

namespace Codewall {

public class Toolbar : Gtk.Toolbar {

    public ToolButton open_button;
    public ToolButton save_button;
    public ToolButton undo_button;
    public ToolButton redo_button;
    public ToolButton new_button;

    public Toolbar(Gtk.ActionGroup actions) {
      
      
      this.open_button = actions.get_action("Open").create_tool_item() as Gtk.ToolButton;
      this.save_button = actions.get_action("Save").create_tool_item() as Gtk.ToolButton;
      this.undo_button = actions.get_action("Undo").create_tool_item() as Gtk.ToolButton;
      this.redo_button = actions.get_action("Redo").create_tool_item() as Gtk.ToolButton;
      this.new_button = actions.get_action("New").create_tool_item() as Gtk.ToolButton;
      
      this.open_button.set_icon_widget(new Image.from_icon_name("folder", IconSize.LARGE_TOOLBAR));
      this.save_button.set_icon_widget(new Image.from_icon_name("media-memory-sm", IconSize.LARGE_TOOLBAR));
      this.undo_button.set_icon_widget(new Image.from_icon_name("edit-undo", IconSize.LARGE_TOOLBAR));      
      this.redo_button.set_icon_widget(new Image.from_icon_name("edit-redo", IconSize.LARGE_TOOLBAR));
      this.new_button.set_icon_widget(new Image.from_icon_name("document-new", IconSize.LARGE_TOOLBAR));
      
      this.add(open_button);
      this.add(new_button);
      this.add(save_button);
      this.add(undo_button);
      this.add(redo_button);
      
      this.undo_button.set_sensitive(false);
      this.redo_button.set_sensitive(false);
      
      this.save_button.no_show_all = true;
      this.save_button.set_visible(false);
      
      this.new_button.no_show_all = false;
      this.new_button.set_visible(true);
      
      show_all();
    }

  }
}