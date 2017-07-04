# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
tableToggle =
  selectedRowId: ''

  openInlineEditForm: (this_) ->
    id = $(this_).data(this.data)
    this.toggleRow(id)
    this.selectedRowId = id

  closeOpenedRow: (e) ->
    row = $(this.id.form + this.selectedRowId)
    if !row.is(e.target) and row.find(e.target).length == 0
      this.toggleRow(this.selectedRowId)
      this.selectedRowId = null

  toggleRow: (id) ->
    $(this.id.row  + id).toggle()
    $(this.id.form + id).toggle()

  id:
    form: "#edit_form_"
    row:  "#edit_row_"

  data: 'objectId'

$(document).on "turbolinks:load", ->
  $('.open_edit_form').click ->
    tableToggle.openInlineEditForm(this)

  $(document).mouseup (e) ->
    tableToggle.closeOpenedRow(e)

  element = $('.tree_element .visible_element')
  element.draggable()
  element.droppable(
    activeClass: 'activated'
    hoverClass: 'hovered'
  )
