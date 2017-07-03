$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    openInlineEditForm(this)

  $('.close_edit_form').click (e) ->
    e.preventDefault()
    closeInlineEditForm(this)

openInlineEditForm = (this_) ->
  id = $(this_).data('objectId')
  $(".edit_form").hide()
  $(".edit_row").show()
  toggleConcreteRow(id)

closeInlineEditForm = (this_) ->
  id = $(this_).data('objectId')
  toggleConcreteRow(id)

toggleConcreteRow = (id) ->
  $("#edit_row_"  + id).toggle()
  $("#edit_form_" + id).toggle()
