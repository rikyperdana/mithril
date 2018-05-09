if Meteor.isClient

	comp =
		table: (fields) ->
			datas =
				if m.route.param \fields
					_.filter coll.find!fetch!, (i) ->
						m.route.param(\fields) is (.toString!) _.tail _.keys i
				else coll.find!fetch!
			rowEvent = (i) ->
				onclick: -> state[fields.toString!] = i
				ondblclick: ->
					Meteor.call \remove, i
					state[fields.toString!] = null
			view: -> m \table.bordered,
				m \thead, m \tr, _.map fields, (i) ->
					m \th, _.startCase i
				m \tbody, _.map datas, (doc) ->
					m \tr, rowEvent(doc), _.map doc, (val, key) ->
						m \td, _.startCase val unless key is \_id

		form: (fields) ->
			formEvent =
				onsubmit: (e) ->
					e.preventDefault!
					zip = _.zipObject fields, _.map fields, (i) ->
						e.target.children[i]value
					zip._id = state[fields.toString!]?_id
					Meteor.call \upsert, zip
					state[fields.toString!] = null
			view: -> m \form, formEvent,
				_.map fields, (i) -> m \input,
					name: i
					placeholder: _.startCase i
					value: state[fields.toString!]?[i] or ''
				m \input.btn, type: \submit

		crud: (fields) ->
			view: -> m \.container,
				m \h4, 'Mithril CRUD'
				m \.row, _.map <[ form table ]>, (i) ->
					m \.col.m6, m comp[i] fields
				m \p, '1 click to update, 2 click to remove'

		menus: ->
			view: -> m \div,
				m \.navbar-fixed, m \nav, m \.nav-wrapper,
					m \a.brand-logo.center, \CRUD
					m \ul.right,
						m \li, m \a, \Login
						m \li, m \a, \Register
				m \ul.fixed.side-nav,
					m \li, m \a.center, m \b, 'Crud List'
					do ->
						_.uniq _.map coll.find!fetch!, (i) ->
							(.toString!) _.tail _.keys i
						.map (i) -> m \li, m \a,
							href: "/menus/#i", oncreate: m.route.link, _.startCase i
				if m.route.param \fields
					m comp.crud (.split \,) m.route.param \fields

	Meteor.subscribe \coll, onReady: ->
		m.route document.body, \/menus,
			'/table': comp.table <[ name address ]>
			'/form': comp.form <[ name address ]>
			'/crud': comp.crud <[ name address ]>
			'/menus': comp.menus!
			'/menus/:fields': comp.menus!

	coll.find!observe do
		added: -> m.redraw!
		removed: -> m.redraw!
		changed: -> m.redraw!
