/* Copyright 2014 Chad Klassen
 *
 * This file is part of Codewall.
 *
 * Codewall is free software: you can redistribute it
 * and/or modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * Codewall is distributed in the hope that it will be
 * useful, but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
 * Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with Codewall. If not, see http://www.gnu.org/licenses/.
 */
using Gtk;
using Granite.Widgets;
using GLib;

namespace CodeWall {



public class AppWindow : Granite.Application {
	public Gtk.Window window = null;
	private Box layout;
	private Codewall.Toolbar menu;
	private DynamicNotebook tabs;
	private Welcome welcome;
	private FileChooserDialog openDialog;
	private Granite.Widgets.AboutDialog AboutDialog;
	private Gtk.Menu cogMenu;
	private Datalist<Gtk.MenuItem> cogMenuItems;
	private PageDecorator pageDecorator;
	private Utilities utilities;
	private Gtk.ActionGroup main_actions;
	private UIManager ui;


	public static Codewall.InfoBar infobar;


	public AppWindow() {

		this.application_id = "apps.codewall";
		this.flags = ApplicationFlags.HANDLES_COMMAND_LINE;

		//This is the default constructor for the new window.
		//Gtk.Window.set_interactive_debugging(true);
		this.window = new Gtk.Window();


		this.window.title = "Codewall";         // Define the window title
		this.window.set_default_size(600, 600);         // Define the intial size of the window.
		this.window.destroy.connect(Gtk.main_quit); // Clicking the close button will fully terminate the program.

		this.window.delete_event.connect(close_action);


		this.window.set_position(Gtk.WindowPosition.CENTER); // Launch the program in the center of the screen
		this.app_icon = "text-x-generic-template";

		try {
			this.window.set_icon_from_file("../data/icon.png");
		}
		catch (Error e) {
			warning(e.message);
		}
		this.init();
		this.configMenu();
		this.buildTabs();
		this.connections();



	}

	public override void activate () {

		warning("activated");
	}





	/*
	   ---------------------------------------------------------------------
	               GETTERS AND SETTERS
	   ---------------------------------------------------------------------
	 */



	/*
	   ---------------------------------------------------------------------
	                INIT FUNCTIONS
	   ---------------------------------------------------------------------
	 */


	/**
	 * Lets make sure we initialize everything.
	 */
	private void init() {
		this.utilities = new Utilities();
		this.pageDecorator = new PageDecorator();
		this.layout = new Box(Orientation.VERTICAL, 0);
		this.window.add(layout);

		this.main_actions = new Gtk.ActionGroup("MainActionGroup");


		/*
		   This will also connect the actions to the real buttons.
		 */
		Gtk.ActionEntry[] action_entries = new Gtk.ActionEntry[8];
		action_entries[0] = { "Quit", null, N_("Quit"), "<Control>q", N_("Quit"), () => { if (!close_action(null)) {Gtk.main_quit(); }} };
		action_entries[1] = { "Open", N_("_Open"), N_("Open"), "<Control>o", N_("Open"), openButton_clicked};
		action_entries[2] =  { "New", N_("_New"), N_("New"), "<Control>n", N_("New"), firstTabAdded};
		action_entries[3] = {"Save", N_("Save"), N_("Save"), "<Control>s", N_("Save"), saveButton_clicked};
		action_entries[4] = {"Undo", N_("Undo"), N_("Undo"), "<Control>z", N_("Undo"), undoButton_clicked};
		action_entries[5] = {"Redo", N_("Redo"), N_("Redo"), "<Control><shift>z", N_("Redo"), redoButton_clicked};
		action_entries[6] = {"AutoFormat", null, N_("AutoFormat"), "<Control><shift>f", N_("AutoFormat"), autoFormatCode_action};
		action_entries[7] = {"Goto", N_("Goto"), N_("Goto"), "<Control>l", N_("Goto"),gotoButton_clicked};



		this.main_actions.add_actions(action_entries, this);



		this.ui = new UIManager();
		try {
			ui.add_ui_from_file("/usr/local/share/codewall/ui.xml");
		}
		catch (Error e) {
			error("Couldnt load UI %s", e.message);
		}

		Gtk.AccelGroup accel_group = ui.get_accel_group();
		this.window.add_accel_group (accel_group);

		ui.insert_action_group(main_actions,0);
		ui.ensure_update();

		this.menu = new Codewall.Toolbar(main_actions);


		this.layout.pack_start(this.menu, false, false);

		this.infobar = new Codewall.InfoBar();
		this.infobar.hide();

		this.layout.pack_start(this.infobar, false,false);

		this.welcome = new Welcome("Welcome to Codewall", "");
		this.welcome.append_with_image(new Image.from_icon_name("document-new", IconSize.BUTTON), "Create", "Make a new document");
		this.welcome.append_with_image(new Image.from_icon_name("folder", IconSize.BUTTON), "Open", "Open a document");
		//this.welcome.set_no_show_all(true);

		this.layout.pack_start(this.welcome,true,true);
		//Set so the save button isnt visible


	}


	/*
	    This is where all the connections are made. No lambda functions allowed. Newer versions of
	    vala dont allow annoyamous functions for connections.
	 */
	private void connections() {
		this.welcome.activated.connect(welcome_actions);

		this.tabs.tab_switched.connect_after(tabSwitchedSequence);

		//Connect onclick of preference menu item.
		this.getMenuItem("pref").activate.connect(displayPreferences);

		this.utilities.preferencesChanged.connect(preferences_changed);
		this.tabs.tab_removed.connect(close_tab_action);
		this.window.focus_activated.connect(()=>{warning("Window Focused"); }
		);
	}

	private void buildTabs() {
		this.tabs = new DynamicNotebook();
		this.tabs.add_button_visible = true;
		this.tabs.show_tabs = true;

		this.tabs.allow_restoring = true;
		this.tabs.no_show_all = true;
		this.layout.pack_start(tabs);
	}

	private void configMenu() {
		this.cogMenu = new Gtk.Menu();
		this.program_name = "Codewall";
		AppMenu cog = this.create_appmenu(this.cogMenu);
		//AppMenu cog = this.ui.get_widget("ui/AppMenu") as AppMenu;

		this.setMenuItem("pref", new Gtk.MenuItem.with_label("Preferences"));
		this.cogMenu.add(this.getMenuItem("pref"));
		this.cogMenu.reorder_child(this.getMenuItem("pref"),0);



		SeparatorToolItem sep = new SeparatorToolItem();
		sep.set_draw(false);
		sep.set_expand(true);

		this.menu.add(sep);
		this.menu.add(cog);



	}


	/*
	   ---------------------------------------------------------------------
	                HELPER FUNCTIONS
	   ---------------------------------------------------------------------
	 */
	private void setMenuItem(string key, Gtk.MenuItem value) {
		this.cogMenuItems.set_data(key, value);
	}
	private Gtk.MenuItem getMenuItem(string key) {
		return this.cogMenuItems.get_data(key);
	}


	private void set_welcome_visible(bool val) {
		this.welcome.set_visible(val);
		this.tabs.set_visible(!val);
		this.welcome.no_show_all = !val;
		if (val) {
			this.welcome.show_all();
		}

		this.menu.save_button.icon_widget.set_visible(!val);
		this.menu.save_button.set_visible(!val);
		this.menu.new_button.icon_widget.set_visible(val);
		this.menu.new_button.set_visible(val);

	}


	/*
	    This is where the connection functions go.
	 */
	private void welcome_actions(int index) {

		switch (index) {
		case 0: this.firstTabAdded(); break;
		case 1: this.openButton_clicked(); break;
		}
	}


	/*
	   ---------------------------------------------------------------------
	                CONNECTION FUNCTIONS
	   ---------------------------------------------------------------------
	 */
	private void close_tab_action(Tab tab) {

		Page page = (Page)tab.page;
		bool close_tab = true;

		//If the file does not have a file path and it has some text in the buffer
		if (page.filepath == "" && page.buffer.text.length > 0) {

			var msg = Utilities.drawMessageDialog("Document not saved. Continue?", Gtk.MessageType.WARNING, Gtk.ButtonsType.OK_CANCEL);
			int responseID = msg.run();

			if (responseID == Gtk.ResponseType.OK) {
				close_tab = true;
			}
			else{
				close_tab = false;
			}

			msg.destroy();

		}
		else if (page.filepath == "" && page.buffer.text.length == 0) {

		}
		else {
			page.write();
		}

		if (close_tab && this.tabs.n_tabs == 1) {
			this.set_welcome_visible(true);
			this.menu.undo_button.set_sensitive(false);
			this.menu.redo_button.set_sensitive(false);

		}

		//return close_tab;
	}


	/*
	   Action executed when the key combination <Control><Shift>f is pressed.
	   It uses an external program called crustify to format the code. Should
	   indicate if the program is not installed.
	 */
	private void autoFormatCode_action() {

		string output = "";
		//@TODO run check to see if command is available. Skip and display error if doesn't exist

		this.get_current_page().write();
		string cmd =  "/usr/bin/uncrustify -q -c /usr/local/share/codewall/uncrustify.cfg -f ";
		cmd += this.get_current_page().filepath;
		cmd += " -o ";
		cmd += this.get_current_page().filepath;

		string stderror = "";
		int exitstatus = 0;
		try {
			//@TODO save which line its on now.
			GLib.Process.spawn_command_line_sync(cmd, out output, out stderror, out exitstatus);
			//@TODO go to that line or the closest line. Reason: Formatting is too disorienting.
			this.get_current_page().reloadFile();
		}
		catch (SpawnError e) {

		}

		if (output == null) {
			Utilities.drawMessageDialog("No formatting happened, uncrustify is probably not installed.");
		}

	}


	/*
	   This is what runs when the gotoButton is clicked.
	   Essentially a dialog appears asking for a line number and it will go to that
	   line once the dialog is submitted.
	 */
	private void gotoButton_clicked() {

		if (!this.welcome.get_visible()) {

			int line = this.utilities.gotoLineDialog(this.window);


			if (line > 0) {
				TextIter iter;
				this.get_current_page().buffer.get_start_iter(out iter);
				this.get_current_page().buffer.get_iter_at_line(out iter, line-1);
				this.get_current_page().buffer.place_cursor(iter);
				this.get_current_page().view.scroll_to_iter(iter, 0.0, true, 0, 0.5);
			}
		}
	}


	/*
	   Undo button click action.
	   It undoes the changes that were last made. It also sets the undo button sensitivity
	   if there is no undo actions left.
	 */
	private void undoButton_clicked() {
		Page current = this.get_current_page();
		if (current.buffer.can_undo) {
			this.menu.undo_button.set_sensitive(false);
			//this.setButtonSensitive("undo", false);
		}

		current.buffer.undo();
		current.buffer.changed();
	}


	/*
	   Same as undo button action opposite direction.
	 */
	private void redoButton_clicked() {
		Page current = this.get_current_page();

		if (current.buffer.can_redo) {
			this.menu.redo_button.set_sensitive(false);
			//	this.setButtonSensitive("redo", false);
		}

		current.buffer.redo();
		current.buffer.changed();
	}


	/*
	   The save button only appears when there is a new page.
	   The other save is in the buffer change.
	 */
	private void saveButton_clicked() {
		Page page = this.get_current_page();

		if (page.save()) {

			if (this.menu.save_button.visible) {
				this.menu.save_button.set_visible(false);
			}

		}

		this.pageDecorator.decoratePage(page);
	}


	/*
	   Open button click action. Will make the open button dialog
	   visible.
	 */
	private void openButton_clicked() {
		Utilities util = new Utilities();
		this.openDialog = util.dialog(this.window);
		if (this.openDialog.run() == ResponseType.ACCEPT) {
			SList<string> filenames = this.openDialog.get_filenames();

			//warn_if_fail(uris.length() != filenames.length());
			for(int i = 0; i < filenames.length(); i++) {
				this.loadFile(filenames.nth_data(i));
			}
		}

		this.openDialog.destroy();
	}


	/*
	   this action happens when we want the close to happen. Its encapsulated because
	   we want to check to see if there is any unsaved documents (new documents) before
	   we close the program.
	 */
	private bool close_action(Gdk.EventAny ? event) {

		bool displaydialog = false;

		foreach(Tab tab in this.tabs.tabs) {
			Page current = (Page)tab.page;
			if (current.filepath == "" && current.buffer.text.length > 0 ) {
				displaydialog = true;
			}
			else{
				current.write();
			}

		}

		if (displaydialog) {
			MessageDialog msg = Utilities.drawMessageDialog("There are unsaved documents. Would you like to continue?", MessageType.WARNING, ButtonsType.OK_CANCEL);

			msg.response.connect((response_id) => {
				        switch (response_id) {
					case Gtk.ResponseType.OK :
						Gtk.main_quit();
						break;
					}
				        msg.destroy();
				}
			);
		}

		return displaydialog;

	}




	/*
	   Load the file that is represented by the file path into a new
	   tab, and page.
	   @param filepath
	   @return bool
	 */
	public bool loadFile(string filepath) {

		string[] chunks = filepath.split("/");
		Tab tab_temp = null;
		
		if (FileUtils.test(filepath, FileTest.IS_SYMLINK)) {
		  AppWindow.infobar.set_properties("Could not open file because it is a symbolic link", null, true, MessageType.WARNING);
		  return false;
		}
		bool exists = this.pageExists(filepath, out tab_temp);

		if (!exists) {

			string temp = "";
			File file = File.new_for_path(filepath);
			try {
				FileUtils.get_contents(filepath, out temp);
				Page page = this.loadContentIntoPage(temp, chunks[chunks.length-1], file.get_path());
				return true;
			}
			catch (FileError e) {
				try {
					FileUtils.set_contents(filepath, "");
					Page page = this.loadContentIntoPage("", chunks[chunks.length-1], file.get_path());
				}
				catch (FileError e) {

					this.infobar.set_properties("Could not make new file at "+file.get_path(), null, true, MessageType.WARNING);
					ulong handler = this.infobar.button.clicked.connect(()=>{this.infobar.hide(); }
					                );
					this.infobar.disconnect(handler);
				}
			}

		}
		else {

			this.tabSwitchedSequence(null, tab_temp);
			return true;
		}

		return false;
	}


	/*
	   On buffer changed. Do what you need to do here when someone is typing in the buffer.

	 */
	private void buffer_changed() {
		Page current = this.get_current_page();
		//this.setButtonSensitive("redo", current.buffer.can_redo);
		this.menu.redo_button.set_sensitive(current.buffer.can_redo);
		if (current.buffer.text.length > 0) {
			//			this.setButtonSensitive("undo", current.buffer.can_undo);
			this.menu.undo_button.set_sensitive(current.buffer.can_undo);
		}
		else{
			this.menu.undo_button.set_sensitive(current.buffer.can_undo);
			//	this.setButtonSensitive("undo", false);
		}
	}

	private void tabSwitchedSequence(Tab ? oldTab, Tab newTab) {
		//This replaces the tab_added signal. Because tab_switched is the only one that gets emitted.
		if (!(newTab.page is Page)) {
			this.assignPage(newTab);
		}

		Page current = (Page)newTab.page;
		this.menu.undo_button.set_sensitive(current.buffer.can_undo);
		//this.setButtonSensitive("undo", current.buffer.can_undo);
		this.menu.redo_button.set_sensitive(current.buffer.can_redo);
		//this.setButtonSensitive("redo", current.buffer.can_redo);

		current.buffer.changed.connect(buffer_changed);

		//current.saveable.connect(saveButtonSensitive);

		//See if the currently focused page has been saved to disk if it has then hide the save icon. Else show it.
		//this.getButton("save").set_visible(!current.hasFilePath());
		this.menu.save_button.set_visible(!current.hasFilePath());
		//this.getButton("new").set_visible(false);


	}


	/*
	    Action to display the preferences dialog.
	 */
	private void displayPreferences() {
		Dialog pref = this.utilities.preferences(this.window, this.pageDecorator);
	}


	/*
	    After preference dialog has been accepted. This is
	    where all the operations need to be handled. Then redecoration of
	    all the open pages.
	 */
	private void preferences_changed() {
		//Need to redecorate all the pages.
		this.pageDecorator.decoratePages(this.tabs.tabs);

	}


	private Page get_current_page() {
		return (Page) this.tabs.current.page;
	}

	private void assignPage(Tab tab) {
		tab.label = "New Document";
		Page page = new Page(tab);
		tab.page = page;
		this.pageDecorator.decoratePage(page);

	}



	private void firstTabAdded() {
		Tab tab = new Tab();
		this.assignPage(tab);
		this.tabs.insert_tab(tab,0);
		this.set_welcome_visible(false);

	}

	private Page loadContentIntoPage( string content = "", string title = "", string filepath = "") {

		Tab tab = new Tab();
		tab.label = title;
		Page page = new Page(tab, content, title);
		page.filepath = filepath;

		tab.page = page;

		pageDecorator.decoratePage(page);

		this.tabs.insert_tab(tab,0);

		//Set welcome screen to not visible.
		this.set_welcome_visible(false);

		//Set the newly created tab as the current.
		this.tabs.current = tab;

		//this.getButton("save").set_visible(false);
		this.menu.save_button.set_visible(false);
		//this.getButton("new").set_visible(false);
		this.menu.new_button.set_visible(false);
		return page;
	}

	private bool pageExists(string filename, out Tab found) {

		foreach (Tab i in this.tabs.tabs) {
			Page page = (Page)i.page;

			if (page.filepath == filename) {
				this.tabs.current = i;
				found = i;
				return true;
			}

		}
		return false;

	}










	public void show_all() {
		this.window.show_all();
	}
	public bool is_showing() {
		return this.window.get_visible();
	}






	private int _command_line (ApplicationCommandLine command_line) {
		bool version = false;
		bool newInstance = false;

		string[] ? files = null;


		OptionEntry[] options = new OptionEntry[3];
		options[0] = { "version", 0, 0, OptionArg.NONE, ref version, "Display version number", null };
		options[1] = { "", 'f', 0, OptionArg.FILENAME_ARRAY, ref files, "Open files using FILEPATH", "FILEPATH" };
		options[2] = { "new", 'n', 0, OptionArg.NONE, ref newInstance, "Open a new instance of codewall.", null };

		// We have to make an extra copy of the array, since .parse assumes
		// that it can remove strings from the array without freeing them.
		string[] args = command_line.get_arguments ();
		string*[] _args = new string[args.length];
		for (int i = 0; i < args.length; i++) {
			_args[i] = args[i];
		}

		try {
			var opt_context = new OptionContext ("- OptionContext example");
			opt_context.set_help_enabled (true);
			opt_context.add_main_entries (options, null);
			unowned string[] tmp = _args;
			opt_context.parse (ref tmp);
		}
		catch (OptionError e) {
			command_line.print ("error: %s\n", e.message);
			command_line.print ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
			return 0;
		}

		if (version) {
			command_line.print ("Test 0.1\n");
			//return 0;
		}

		if (files != null) {

			for(int i = 0; files[i] != null; i++) {
				if (this.loadFile(files[i])) {

					this.set_welcome_visible(false);
					this.menu.new_button.no_show_all = true;
					this.menu.save_button.no_show_all = true;
					this.menu.save_button.set_visible(false);
				}
			}

		}


		/*
		    Return 1 if the window is already visible. This will prevent another window from opening
		    even though files will be loaded into the original window.
		 */
		if (this.window.visible && !newInstance) {
			return 0;
		}

		return 1;
	}

	public override int command_line (ApplicationCommandLine command_line) {
		// keep the application running until we are done with this commandline
		this.hold ();
		int res = _command_line (command_line);
		this.release ();
		return res;
	}


	/**
	 * Much like other programming langauges such as Java, we will define our main
	 * execution loop as a static method.
	 */
	public static int main(string[] args) {
		Gtk.init(ref args);
		AppWindow app = new AppWindow();


		int status =  app.run(args);

		if (status == 1) {
			app.show_all();
			Gtk.main();
		}

		return status;
	}
}
}
