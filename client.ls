if Meteor.isClient

	comp = {}; state = {}

	comp.table = (fields) ->
		datas = coll.find!fetch!
		rowEvent = (i) ->
			onclick: -> state[fields.toString!] = i
			ondblclick: -> Meteor.call \remove, i
		view: -> m \table.bordered,
			m \thead, m \tr, _.map fields, (i) ->
				m \th, _.startCase i
			m \tbody, _.map datas, (doc) ->
				m \tr, rowEvent(doc),
					_.map doc, (val, key) ->
						unless key is \_id
							m \td, _.startCase val

	comp.form = (fields) ->
		formEvent =
			onsubmit: (e) ->
				e.preventDefault!
				state[fields.toString!] = null
				Meteor.call \upsert, _.zipObject fields,
					_.map fields, (i) ->
						e.target.children[i]value
		view: -> m \form, formEvent,
			_.map fields, (i) -> m \input,
				name: i
				placeholder: _.startCase i
				value: state[fields.toString!]?[i] or ''
			m \input.btn, type: \submit

	comp.crud = (fields) ->
		view: -> m \.container,
			m \h4, 'Mithril CRUD'
			m \.row, _.map <[ form table ]>, (i) ->
				m \.col.m6, m comp[i] fields

	Meteor.subscribe \coll, onReady: ->
		m.route document.body, \/crud,
			'/table': comp.table <[ nama alamat ]>
			'/form': comp.form <[ nama alamat ]>
			'/crud': comp.crud <[ nama alamat ]>

	coll.find!observe do
		added: -> m.redraw!
		removed: -> m.redraw!
