if Meteor.isServer

	Meteor.publish \coll, -> coll.find {}

	Meteor.methods do
		upsert: (doc) -> coll.upsert doc._id, doc
		remove: (doc) -> coll.remove doc._id
