# SPDX-FileCopyrightText: © Serhii “GooRoo” Olendarenko
# SPDX-FileContributor: Serhii Olendarenko <sergey.olendarenko@gmail.com>
#
# SPDX-License-Identifier: BSD-3-Clause

def supported-languages []: nothing -> list<string> {
	return [
		brazilian bulgarian czech      danish
		dutch     english   finnish    french
		german    greek     hungarian  indonesian
		italian   japanese  koreana    latam
		norwegian polish    portuguese romanian
		schinese  spanish   swedish    tchinese
		thai      turkish   ukrainian  vietnamese
	]
}

def app-details-filters []: nothing -> list<string> {
	return [
		type
		name
		steam_appid
		required_age
		dlc
		detailed_description
		about_the_game
		supported_languages
		detailed_description
		supported_languages
		header_image
		website
		pc_requirements
		mac_requirements
		linux_requirements
	]
}

def parse-id []: string -> int {
	parse -r '/app/(?<id>\d+)/' | get id.0
}

# Get information about the game
#
# Pass either an ID of the game or a store URL via pipe.
@category api
@search-terms steam api game info
@example "Get details by ID" {1328670 | steam app-details}
@example "Get details by store URL" {'https://store.steampowered.com/app/1328670/Mass_Effect_Legendary_Edition/' | steam app-details}
export def app-details [
	--lang (-l): string@supported-languages = english  # The language of the information to retrieve
	--filters (-f): list<string>                       # Limit fields to retrieve
]: [
	int -> table
	string -> table
] {
	let pipe_in = $in

	let lang = if $lang == 'russian' { 'ukrainian' } else { $lang }

	let game_id = match ($pipe_in | describe) {
		'int' => $pipe_in
		'string' => { $pipe_in | parse-id }
	}

	http get $'https://store.steampowered.com/api/appdetails?appids=($game_id)&l=($lang)&filters=($filters | default [] | str join ",")'
		| transpose -d
		| rename id response
		| select --optional id response.success response.data
		| rename id success data
		| flatten data
		| update cells -c [supported_languages] {|value|
			$value
			| split row ", "
			| parse -r '(?<language>[\w\s()]+)(?<audio><strong>\*</strong>)?(?:<br>.+)?'
			| insert text true
			| update audio {|row| $row.audio != null}
		}
		| reject --optional data
}

# Get price information on one or more games
#
# Pass an ID, a URL or a list of those via pipe.
@category api
@search-terms steam api game info price
@example "Get prices for a single game" {'https://store.steampowered.com/app/1328670/Mass_Effect_Legendary_Edition/' | steam price-overview} --result [
	[id success currency initial final discount_percent initial_formatted final_formatted];
	[1328670 true EUR 5999 479 92 '59,99€' '4,79€']
]
@example "Get prices for several games" {[1328670 1091500 123123123123] | steam price-overview} --result [
	[id success currency initial final discount_percent initial_formatted final_formatted];
	[1328670 true EUR 5999 479 92 '59,99€' '4,79€']
	[1091500 true EUR 5999 5999 0 '' '59,99€']
	[123123123123 false null null null null null null]
]
export def price-overview []: [
	int -> table
	string -> table
	list<oneof<int,string>> -> table
] {
	let pipe_in = $in

	let game_ids = match ($pipe_in | describe -d).type {
		'int' => { [$pipe_in] }
		'string' => { [($pipe_in | parse-id)] }
		'list' => {
			$pipe_in | each {|it|
				match ($it | describe) {
					'int' => $it
					'string' => { $it | parse-id }
					_ => null
				}
			} | compact
		}
	}

	http get $'https://store.steampowered.com/api/appdetails?appids=($game_ids | str join ",")&filters=price_overview'
		| transpose -d
		| rename id response
		| select --optional id response.success response.data.price_overview
		| rename id success data
		| flatten data
		| reject --optional data
}
