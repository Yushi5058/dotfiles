--- @diagnostic disable: undefined-global
--- @alias Mode Mode Comes from Yazi.
--- @alias Line Line Comes from Yazi.
--- @alias Span Span Comes from Yazi.
--- @alias Color Color Comes from Yazi.
--- @alias Config Config The config used for setup.
--- @alias Coloreds Coloreds The array returned by colorizer in {{string, Color}, {string, Color} ... } format
--- @alias Side # [ LEFT ... RIGHT ]
--- | `enums.LEFT` # The left side of either the header-line or status-line. [ LEFT ... ]
--- | `enums.RIGHT` # The right side of either the header-line or status-line. [ ... RIGHT]
--- @alias SeparatorType
--- | `enums.OUTER` # Separators on the outer side of sections. [ c o | c o | c o ... ] or [ ... o c | o c | o c ]
--- | `enums.INNER` # Separators on the inner side of sections. [ c i c | c i c | c i c ... ] or [ ... c i c | c i c | c i c ]
--- @alias ComponentType
--- | `enums.A` # Components on the first section. [ A | | ... ] or [ ... | | A ]
--- | `enums.B` # Components on the second section. [ | B | ... ] or [ ... | B | ]
--- | `enums.C` # Components on the third section. [ | | C ... ] or [ ... C | | ]

--==================--
-- Type Declaration --
--==================--

local Side = { LEFT = 0, RIGHT = 1 }
local SeparatorType = { OUTER = 0, INNER = 1 }
local ComponentType = { A = 0, B = 1, C = 2 }

os.setlocale("")

--=========================--
-- Variable Initialization --
--=========================--

local section_separator_open
local section_separator_close

local part_separator_open
local part_separator_close

local separator_style = { bg = "black", fg = "black" }

local style_a
local style_b
local style_c

local style_a_normal_bg
local style_a_select_bg
local style_a_un_set_bg

local permissions_t_fg
local permissions_r_fg
local permissions_w_fg
local permissions_x_fg
local permissions_s_fg

local tab_width

local selected_icon
local copied_icon
local cut_icon

local selected_fg
local copied_fg
local cut_fg

local section_order = { "section_a", "section_b", "section_c" }

--=================--
-- Component Setup --
--=================--

--- Sets the background of style_a according to the tab's mode.
--- @param mode Mode The mode of the active tab.
--- @see cx.active.mode To get the active tab's mode.
local function set_mode_style(mode)
	if mode.is_select then
		style_a.bg = style_a_select_bg
	elseif mode.is_unset then
		style_a.bg = style_a_un_set_bg
	else
		style_a.bg = style_a_normal_bg
	end
end

--- Sets the style of the separator according to the parameters.
--- While selecting component type of both previous and following components,
--- always think separator is in middle of two components
--- and previous component is in left side and following component is in right side.
--- Thus, side of component does not important when choosing these two components.
--- @param separator_type SeparatorType Where will there be a separator in the section.
--- @param component_type ComponentType Which section component will be in [ a | b | c ].
local function set_separator_style(separator_type, component_type)
	if separator_type == SeparatorType.OUTER then
		if component_type == ComponentType.A then
			separator_style.bg = style_b.bg
			separator_style.fg = style_a.bg
		elseif component_type == ComponentType.B then
			separator_style.bg = style_c.bg
			separator_style.fg = style_b.bg
		else
			separator_style.bg = style_c.bg
			separator_style.fg = style_c.bg
		end
	else
		if component_type == ComponentType.A then
			separator_style.bg = style_a.bg
			separator_style.fg = style_a.fg
		elseif component_type == ComponentType.B then
			separator_style.bg = style_b.bg
			separator_style.fg = style_b.fg
		else
			separator_style.bg = style_c.bg
			separator_style.fg = style_c.fg
		end
	end
end

--- Sets the style of the component according to the its type.
--- @param component Span Component that will be styled.
--- @param component_type ComponentType Which section component will be in [ a | b | c ].
--- @see Style To see how to style, in Yazi's documentation.
local function set_component_style(component, component_type)
	if component_type == ComponentType.A then
		component:style(style_a):bold()
	elseif component_type == ComponentType.B then
		component:style(style_b)
	else
		component:style(style_c)
	end
end

--- Connects component to a separator.
--- @param component Span Component that will be connected to separator.
--- @param side Side Left or right side of the either header-line or status-line.
--- @param separator_type SeparatorType Where will there be a separator in the section.
--- @return Line line A Line which has component and separator.
local function connect_separator(component, side, separator_type)
	local open, close
	if separator_type == SeparatorType.OUTER then
		open = ui.Span(section_separator_open)
		close = ui.Span(section_separator_close)
	else
		open = ui.Span(part_separator_open)
		close = ui.Span(part_separator_close)
	end

	open:style(separator_style)
	close:style(separator_style)

	if side == Side.LEFT then
		return ui.Line({ component, close })
	else
		return ui.Line({ open, component })
	end
end

--- Creates a component from given string according to other parameters.
--- @param string string The text which will be shown inside of the component.
--- @param side Side Left or right side of the either header-line or status-line.
--- @param component_type ComponentType Which section component will be in [ a | b | c ].
--- @param separator_type SeparatorType Where will there be a separator in the section.
--- @return Line line Customized Line which follows desired style of the parameters.
--- @see set_mode_style To know how mode style selected.
--- @see set_separator_style To know how separator style applied.
--- @see set_component_style To know how component style applied.
--- @see connect_separator To know how component and separator connected.
local function create_component_from_str(string, side, component_type, separator_type)
	local span = ui.Span(" " .. string .. " ")
	set_mode_style(cx.active.mode)
	set_separator_style(separator_type, component_type)
	set_component_style(span, component_type)
	local line = connect_separator(span, side, separator_type)

	return line
end

--- Creates a component from given Coloreds according to other parameters.
--- The component it created, can contain multiple strings with different foreground color.
--- @param coloreds Coloreds The array which contains an array which contains text which will be shown inside of the component and its foreground color.
--- @param side Side Left or right side of the either header-line or status-line.
--- @param component_type ComponentType Which section component will be in [ a | b | c ].
--- @param separator_type SeparatorType Where will there be a separator in the section.
--- @return Line line Customized Line which follows desired style of the parameters.
--- @see set_mode_style To know how mode style selected.
--- @see set_separator_style To know how separator style applied.
--- @see set_component_style To know how component style applied.
--- @see connect_separator To know how component and separator connected.
local function create_component_from_coloreds(coloreds, side, component_type, separator_type)
	set_mode_style(cx.active.mode)
	set_separator_style(separator_type, component_type)

	local spans = {}
	for i, colored in ipairs(coloreds) do
		local span = ui.Span(colored[1])
		set_component_style(span, component_type)
		span:fg(colored[2])

		spans[i] = span
	end

	local spans_line = ui.Line(spans)
	local line = connect_separator(spans_line, side, separator_type)

	return line
end

--==================--
-- Helper Functions --
--==================--

--- Gets the file name from given file extension.
--- @param file_name string The name of a file whose extension will be taken.
--- @return string file_extension Extension of a file.
local function get_file_extension(file_name)
	local extension = file_name:match("^.+%.(.+)$")

	if extension == nil or extension == "" then
		return "null"
	else
		return extension
	end
end

--==================--
-- Getter Functions --
--==================--

local get = {}

--- Gets the hovered file's name of the current active tab.
--- @return string name Current active tab's hovered file's name.
function get:hovered_name()
	return cx.active.current.hovered.name
end

--- Gets the hovered file's size of the current active tab.
--- @return string size Current active tab's hovered file's size.
function get:hovered_size()
	local h = cx.active.current.hovered

	return ya.readable_size(h:size() or h.cha.length)
end

--- Gets the hovered file's extension of the current active tab.
--- @param show_icon boolean Whether or not an icon will be shown.
--- @return string file_extension Current active tab's hovered file's extension.
function get:hovered_file_extension(show_icon)
	local file = cx.active.current.hovered
	local cha = file.cha

	local name
	if cha.is_dir then
		name = "dir"
	else
		name = get_file_extension(file.url:name())
	end

	if show_icon then
		local icon = file:icon().text
		return icon .. " " .. name
	else
		return name
	end
end

--- Gets the mode of active tab.
--- @return string mode Active tab's mode.
function get:tab_mode()
	local mode = tostring(cx.active.mode):upper()
	if mode == "UNSET" then
		mode = "UN-SET"
	end

	return mode
end

--- Gets the cursor position in the current active tab.
--- @return string cursor_position Current active tab's cursor position.
function get:cursor_position()
	local cursor = cx.active.current.cursor
	local length = #cx.active.current.files

	return string.format(" %2d/%-2d", cursor + 1, length)
end

--- Gets the cursor position as percentage which is according to the number of files inside of current active tab.
--- @return string percentage Percentage of current active tab's cursor position and number of percentages.
function get:cursor_percentage()
	local percentage = 0
	local cursor = cx.active.current.cursor
	local length = #cx.active.current.files
	if cursor ~= 0 and length ~= 0 then
		percentage = math.floor((cursor + 1) * 100 / length)
	end

	if percentage == 0 then
		return " Top "
	elseif percentage == 100 then
		return " Bot "
	else
		return string.format("%3d%% ", percentage)
	end
end

--- Gets the local date or time values.
--- @param format string Format for giving desired date or time values.
--- @return string date Date or time values.
--- @see os.date To see how format works.
function get:date(format)
	return tostring(os.date(format))
end

--=====================--
-- Component Functions --
--=====================--

local create = {}

--- Creates and returns line component for tabs.
--- @param side Side Left or right side of the either header-line or status-line.
--- @return Line line Customized Line which contains tabs.
--- @see set_mode_style To know how mode style selected.
--- @see set_component_style To know how component style applied.
--- @see connect_separator To know how component and separator connected.
function create:tabs(side)
	local tabs = #cx.tabs
	local lines = {}

	local in_side
	if side == "left" then
		in_side = Side.LEFT
	else
		in_side = Side.RIGHT
	end

	for i = 1, tabs do
		local text = i
		if tab_width > 2 then
			text = ya.truncate(text .. " " .. cx.tabs[i]:name(), { max = tab_width })
		end

		if i == cx.tabs.idx then
			local span = ui.Span(" " .. text .. " ")
			set_mode_style(cx.tabs[i].mode)
			set_component_style(span, ComponentType.A)
			separator_style.fg = style_a.bg
			separator_style.bg = style_c.bg
			lines[#lines + 1] = connect_separator(span, in_side, SeparatorType.OUTER)
		else
			local span = ui.Span(" " .. text .. " ")
			set_component_style(span, ComponentType.C)

			if i == cx.tabs.idx - 1 then
				set_mode_style(cx.tabs[i + 1].mode)
				separator_style.fg = style_c.bg
				separator_style.bg = style_a.bg
				lines[#lines + 1] = connect_separator(span, in_side, SeparatorType.OUTER)
			else
				set_separator_style(SeparatorType.INNER, ComponentType.C)
				lines[#lines + 1] = connect_separator(span, in_side, SeparatorType.INNER)
			end
		end
	end

	if in_side == Side.RIGHT then
		local lines_in_right = {}
		for i = #lines, 1, -1 do
			lines_in_right[#lines_in_right + 1] = lines[i]
		end

		return ui.Line(lines_in_right)
	else
		return ui.Line(lines)
	end
end

--====================--
-- Coloreds Functions --
--====================--

local colorize = {}

--- Gets the hovered file's permissions of the current active tab.
--- @return Coloreds coloreds Current active tab's hovered file's permissions
function colorize:permissions()
	local h = cx.active.current.hovered
	local perm = h.cha:permissions()

	local coloreds = {}
	coloreds[1] = { " ", "black" }

	for i = 1, #perm do
		local c = perm:sub(i, i)

		local fg = permissions_t_fg
		if c == "-" then
			fg = permissions_s_fg
		elseif c == "r" then
			fg = permissions_r_fg
		elseif c == "w" then
			fg = permissions_w_fg
		elseif c == "x" or c == "s" or c == "S" or c == "t" or c == "T" then
			fg = permissions_x_fg
		end

		coloreds[i + 1] = { c, fg }
	end

	coloreds[#perm + 2] = { " ", "black" }

	return coloreds
end

--- Gets the number of selected and yanked files of the active tab.
--- @return Coloreds coloreds Active tab's number of selected and yanked files.
function colorize:count()
	local num_yanked = #cx.yanked
	local num_selected = #cx.active.selected

	local yanked_fg, yanked_icon
	if cx.yanked.is_cut then
		yanked_fg = cut_fg
		yanked_icon = cut_icon
	else
		yanked_fg = copied_fg
		yanked_icon = copied_icon
	end

	local coloreds = {
		{ string.format(" %s %d ", selected_icon, num_selected), selected_fg },
		{ string.format(" %s %d ", yanked_icon, num_yanked), yanked_fg },
	}

	return coloreds
end

--- Gets colored which contains string based component's string and desired foreground color.
--- @param component_name string String based component's name.
--- @param fg Color Desired foreground color.
--- @param params table Array of parameters of string based component.
--- @return Coloreds coloreds Array of solely array of string based component's string and desired foreground color.
function colorize:string_based_component(component_name, fg, params)
	local getter = get[component_name]
	params = params or {}

	if params then
		return { { getter(get, table.unpack(params)), fg } }
	else
		return { { getter(), fg } }
	end
end

--===============--
-- Configuration --
--===============--

--- Automatically creates and configures either header-line
--- or status-line according to their config.
--- @param line Config Configuration of either header-line or status-line.
--- @return table left_components Components array whose components are in left side of the line.
--- @return table right_components Components array whose components are in right side of the line.
local function config_line(line)
	local left_components = {}
	local pre_right_components = {}

	for side, sections in pairs(line) do
		local in_side, side_components
		if side == "left" then
			in_side = Side.LEFT
			side_components = left_components
		else
			in_side = Side.RIGHT
			side_components = pre_right_components
		end

		for _, section in ipairs(section_order) do
			local components = sections[section]
			local num_components = #components

			local in_section
			if section == "section_a" then
				in_section = ComponentType.A
			elseif section == "section_b" then
				in_section = ComponentType.B
			else
				in_section = ComponentType.C
			end

			for j, component in ipairs(components) do
				local in_part
				if j == num_components then
					in_part = SeparatorType.OUTER
				else
					in_part = SeparatorType.INNER
				end

				if component.type == "string" then
					if component.custom then
						side_components[#side_components + 1] =
							create_component_from_str(component.name, in_side, in_section, in_part)
					else
						local getter = get[component.name]

						if component.params then
							side_components[#side_components + 1] = create_component_from_str(
								getter(get, table.unpack(component.params)),
								in_side,
								in_section,
								in_part
							)
						else
							side_components[#side_components + 1] =
								create_component_from_str(getter(), in_side, in_section, in_part)
						end
					end
				elseif component.type == "coloreds" then
					if component.custom then
						side_components[#side_components + 1] =
							create_component_from_coloreds(component.name, in_side, in_section, in_part)
					else
						local colorizer = colorize[component.name]

						if component.params then
							side_components[#side_components + 1] = create_component_from_coloreds(
								colorizer(colorize, table.unpack(component.params)),
								in_side,
								in_section,
								in_part
							)
						else
							side_components[#side_components + 1] =
								create_component_from_coloreds(colorizer(), in_side, in_section, in_part)
						end
					end
				elseif component.type == "line" then
					if component.custom then
						side_components[#side_components + 1] = component.name
					else
						local creator = create[component.name]

						if component.params then
							side_components[#side_components + 1] = creator(create, table.unpack(component.params))
						else
							side_components[#side_components + 1] = creator()
						end
					end
				end
			end
		end
	end

	local right_components = {}
	for i = #pre_right_components, 1, -1 do
		right_components[#right_components + 1] = pre_right_components[i]
	end

	return left_components, right_components
end

---Checks if either header-line or status-line contains components.
---@param line Config Configuration of either header-line or status-line.
---@return boolean show_line Returns yes if it contains components, otherwise returns no.
local function show_line(line)
	local total_components = 0

	for _, side in pairs(line) do
		for _, section in pairs(side) do
			total_components = total_components + #section
		end
	end

	return total_components ~= 0
end

return {
	setup = function(_, config)
		section_separator_open = config.section_separator.open
		section_separator_close = config.section_separator.close

		part_separator_open = config.part_separator.open
		part_separator_close = config.part_separator.close

		style_a = { bg = config.style_a.bg_mode.normal, fg = config.style_a.fg }
		style_b = config.style_b
		style_c = config.style_c

		style_a_normal_bg = config.style_a.bg_mode.normal
		style_a_select_bg = config.style_a.bg_mode.select
		style_a_un_set_bg = config.style_a.bg_mode.un_set

		permissions_t_fg = config.permissions_t_fg
		permissions_r_fg = config.permissions_r_fg
		permissions_w_fg = config.permissions_w_fg
		permissions_x_fg = config.permissions_x_fg
		permissions_s_fg = config.permissions_s_fg

		tab_width = config.tab_width

		selected_icon = config.selected.icon
		copied_icon = config.copied.icon
		cut_icon = config.cut.icon

		selected_fg = config.selected.fg
		copied_fg = config.copied.fg
		cut_fg = config.cut.fg

		if show_line(config.header_line) then
			Header.render = function(self, area)
				self.area = area

				local left_components, right_components = config_line(config.header_line)

				local left_line = ui.Line(left_components)
				local right_line = ui.Line(right_components)

				return {
					ui.Paragraph(area, { left_line }):style(style_c),
					ui.Paragraph(area, { right_line }):align(ui.Paragraph.RIGHT),
				}
			end
		end

		if show_line(config.status_line) then
			Status.render = function(self, area)
				self.area = area

				local left_components, right_components = config_line(config.status_line)

				local left_line = ui.Line(left_components)
				local right_line = ui.Line(right_components)

				return {
					ui.Paragraph(area, { left_line }):style(style_c),
					ui.Paragraph(area, { right_line }):align(ui.Paragraph.RIGHT),
					table.unpack(Progress:render(area, right_line:width())),
				}
			end
		end
		require("yatline"):setup({
			section_separator = { open = "", close = "" },
			part_separator = { open = "", close = "" },

			style_a = {
				fg = "black",
				bg_mode = {
					normal = "#a89984",
					select = "#d79921",
					un_set = "#d65d0e",
				},
			},
			style_b = { bg = "#665c54", fg = "#ebdbb2" },
			style_c = { bg = "#3c3836", fg = "#a89984" },

			permissions_t_fg = "green",
			permissions_r_fg = "yellow",
			permissions_w_fg = "red",
			permissions_x_fg = "cyan",
			permissions_s_fg = "darkgray",

			tab_width = 20,

			selected = { icon = "󰻭", fg = "#d79921" },
			copied = { icon = "", fg = "#98971a" },
			cut = { icon = "", fg = "#cc241d" },

			header_line = {
				left = {
					section_a = {},
					section_b = {},
					section_c = {},
				},
				right = {
					section_a = {},
					section_b = {},
					section_c = {},
				},
			},
			status_line = {
				left = {
					section_a = {
						{ type = "string", custom = false, name = "tab_mode" },
					},
					section_b = {
						{ type = "string", custom = false, name = "hovered_size" },
					},
					section_c = {
						{ type = "string", custom = false, name = "hovered_name" },
					},
				},
				right = {
					section_a = {
						{ type = "string", custom = false, name = "cursor_position" },
					},
					section_b = {
						{ type = "string", custom = false, name = "cursor_percentage" },
					},
					section_c = {
						{ type = "coloreds", custom = false, name = "permissions" },
					},
				},
			},
		})
	end,
}
