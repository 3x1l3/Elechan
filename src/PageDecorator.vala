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

namespace CodeWall {

public class PageDecorator {

	public bool show_line_numbers;
	public bool highlight_syntax;
	public bool highlight_current_line;
	public bool show_margin;
	public string color_scheme;
	public string font_description;
	public bool auto_indent;
	public uint tab_width;
	public int indent_width;
	//public SourceDrawSpacesFlags set_draw_spaces = null;

	public PageDecorator() {
		this.show_line_numbers = true;
		this.highlight_syntax = true;
		this.color_scheme = "solarized-light";
		this.font_description = "Droid Sans Mono, regular 10px";
		this.auto_indent = true;
		this.tab_width = 2;
		this.indent_width = 2;
		//this.set_draw_spaces = SourceDrawSpacesFlags.NONE;
	}


	public void decoratePage(Page page) {

		page.view.set_show_line_numbers(this.show_line_numbers);

		page.view.set_show_right_margin(this.show_margin);
		page.view.set_auto_indent(this.auto_indent);

		page.buffer.set_highlight_syntax(this.highlight_syntax);
		page.view.set_tab_width(this.tab_width);
		page.view.set_indent_width(this.indent_width);

		//if (this.set_draw_spaces != null)
		//page.view.set_draw_spaces(this.set_draw_spaces);

		page.view.set_insert_spaces_instead_of_tabs(true);

		this.setLanguage(page);
		this.setColorScheme(page);
		this.setFont(page);




	}

	private void setLanguage(Page page) {
		bool certainty = false;
		string ctype = ContentType.guess(page.filepath, page.buffer.text.data, out certainty);
		SourceLanguage lang = SourceLanguageManager.get_default().guess_language(page.title, ctype);

		page.buffer.set_language(lang);
	}
	private void setColorScheme(Page page) {
		SourceStyleSchemeManager SSSM = SourceStyleSchemeManager.get_default();
		SSSM.prepend_search_path("/usr/local/share/codewall/StyleSchemes/");
		//@TODO Make this a dynamic location based on variable or whatever
		page.buffer.set_style_scheme(SSSM.get_scheme(this.color_scheme));
	}
	private void setFont(Page page) {
		Pango.FontDescription font = new Pango.FontDescription();
		page.view.override_font(Pango.FontDescription.from_string(this.font_description));
	}

	public void decoratePages(List<Tab> tabs) {
		tabs.foreach((tab) => {

		                     this.decoratePage((Page)tab.page);
			     }
		) ;

	}
}
}