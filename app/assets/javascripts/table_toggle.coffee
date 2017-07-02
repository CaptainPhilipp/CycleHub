$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    id = $(this).data('objectId')
    closeAllForms()
    toggleConcreteRow(id)

  $('.close_edit_form').click (e) ->
    e.preventDefault()
    id = $(this).data('objectId')
    toggleConcreteRow(id)

closeAllForms = ->
  $(".edit_form").hide()
  $(".edit_row").show()

toggleConcreteRow = (id) ->
  $("#edit_row_"  + id).toggle()
  $("#edit_form_" + id).toggle()
