selectedRowId = ''

$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    openInlineEditForm(this)

  $(document).mouseup (e) ->
    row = $("#edit_form_" + selectedRowId)
    if !row.is(e.target) and row.find(e.target).length == 0
      closeOpenedRow()


openInlineEditForm = (this_) ->
  id = $(this_).data('objectId')
  toggleConcreteRow(id)
  selectedRowId = id

closeOpenedRow = ->
  toggleConcreteRow(selectedRowId)
  selectedRowId = null

toggleConcreteRow = (id) ->
  $("#edit_row_"  + id).toggle()
  $("#edit_form_" + id).toggle()

closeAllForms = ->
  $(".edit_form").hide()
  $(".edit_row").show()
