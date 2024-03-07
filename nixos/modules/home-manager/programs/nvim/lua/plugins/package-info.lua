return {
	"vuki656/package-info.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	ft = "json",
	config = {
		colors = {
			up_to_date = "#3C4048", -- Text color for up to date dependency virtual text
			outdated = "#FF0000", -- Text color for outdated dependency virtual text
		},
		autostart = true,
		package_manager = "pnpm",
	},
}
